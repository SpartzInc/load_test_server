#Execution code for applying load test to target
class RunningMan
  attr_accessor :start_time, :end_time

  def initialize(args)
    @test_result = args.fetch :test_result
    @test_schedule = args.fetch :test_schedule
    @load_test_schedules = args.fetch :load_test_schedules
    @steps = self.convert_steps(args.fetch(:steps))

    @runners = Array.new
    @former_runners = Array.new
  end

  def convert_steps(steps)
    steps = steps.to_a
    steps.each { |step|
      if step.scenario_step_request_params
        step.scenario_step_request_params = step.scenario_step_request_params.to_a
      end
    }

    return steps
  end

  def duration
    #Return duration in seconds
    @load_test_schedules.to_a.sum { |load_test_schedule| load_test_schedule.duration * 60 }
  end

  def add_runners(number_of_runners)
    puts "RunningMan: Current Threads(#{@runners.count})".colorize(:yellow)
    puts "RunningMan: Starting Thread Runners, #{number_of_runners}".colorize(:green)

    number_of_runners.times do
      runner = Helpers::SingleRunner.new(steps: @steps)
      runner.start

      @runners.push(runner)
    end
  end

  #FIFO
  def stop_runners(number_of_runners)
    puts "RunningMan: Current Threads(#{@runners.count})".colorize(:yellow)
    puts "RunningMan: Stopping Thread Runners(#{number_of_runners})".colorize(:magenta)

    number_of_runners.times do
      runner_to_stop = @runners.shift
      return unless runner_to_stop

      runner_to_stop.stop
      @former_runners.push(runner_to_stop)
    end
  end

  def pull_data
    data = {
        :response_codes => [],
        :response_times => []
    }

    @runners.each { |runner|
      data[:response_codes] += runner.pull_data(:response_codes)
      data[:response_times] += runner.pull_data(:response_times)
    }

    data[:response_codes] = self.prune_response_codes(data[:response_codes])
    data[:response_times] = self.prune_response_times(data[:response_times])
    return data
  end

  def collect_data
    data = {
        :response_codes => [],
        :response_times => []
    }

    @former_runners.each { |former_runner|
      #Wait for former runner to be finished
      loops = 0
      until former_runner.running == false
        puts 'Waiting for runner to finish'.colorize(:red)

        if loops > 3
          Thread.kill(former_runner.thread)
          break
        end

        loops += 1
        sleep(1)
      end

      data[:response_codes] += former_runner.pull_data(:response_codes)
      data[:response_times] += former_runner.pull_data(:response_times)
    }

    data[:response_codes] = self.prune_response_codes(data[:response_codes])
    data[:response_times] = self.prune_response_times(data[:response_times])

    return data
  end

  def save_data(data_collection)
    #Add Response Codes/Times
    ActiveRecord::Base.transaction do
      data_collection[:response_codes].each { |time, response_codes_hash|
        response_codes_hash.each { |response_code, number_of_times|
          already_existing_entry = TestResultResponseCode.find_by(
              test_result_id: @test_result.id, datapoint_timestamp: Time.at(time), response_code: response_code)
          if already_existing_entry
            already_existing_entry.number_of_times += number_of_times
            already_existing_entry.save
          else
            TestResultResponseCode.create({
                                              :test_result => @test_result,
                                              :datapoint_timestamp => Time.at(time),
                                              :response_code => response_code,
                                              :number_of_times => number_of_times
                                          })
          end
        }
      }

      data_collection[:response_times].each { |response_time|
        already_existing_entry = TestResultResponseTime.find_by(
            test_result_id: @test_result.id, datapoint_timestamp: response_time[:time])

        if already_existing_entry
          already_existing_entry.response_time_sum += response_time[:response_time_sum]
          already_existing_entry.number_of_times += response_time[:number_of_times]
          already_existing_entry.save
        end

        TestResultResponseTime.create({
                                          :test_result => @test_result,
                                          :datapoint_timestamp => response_time[:time],
                                          :response_time_sum => response_time[:response_time_sum],
                                          :number_of_times => response_time[:number_of_times],
                                      })
      }
    end
  end

  def prune_response_codes(response_codes)
    response_codes_hash = {}

    response_codes.each { |response_code|
      response_code_time = response_code[:time].to_i

      if response_codes_hash.has_key?(response_code_time)
        if response_codes_hash[response_code_time].has_key?(response_code[:response_code])
          response_codes_hash[response_code_time][response_code[:response_code]] += 1
        else
          response_codes_hash[response_code_time][response_code[:response_code]] = 1
        end
      else
        response_codes_hash[response_code_time] = {
            response_code[:response_code] => 1
        }
      end
    }

    return response_codes_hash
  end

  def prune_response_times(response_times)
    response_time_hash = {} #key => timestamp, Array<Response Times>

    response_times.each { |response_time|
      if response_time_hash.has_key?(response_time[:time].to_i)
        response_time_hash[response_time[:time].to_i].push(response_time[:response_time])
      else
        response_time_hash[response_time[:time].to_i] = [response_time[:response_time]]
      end
    }

    parsed_response_times = []
    response_time_hash.each { |time_key, response_times_array|
      response_time_sum = response_times_array.inject { |sum, el| sum + el }.to_f
      parsed_response_times.push({:time => Time.at(time_key),
                                  :response_time_sum => response_time_sum,
                                  :number_of_times => response_times_array.size})
    }

    return parsed_response_times
  end

  #Main method to run load test
  #Contains loop that waits and keeps everything alive
  def run
    self.start_time = Time.now
    self.end_time = Time.now + self.duration

    until Time.now >= self.end_time
      time_difference = (Time.now - self.start_time).to_i

      #Cancel Test Signal
      if Rails.cache.read(:cancel_load_test) == @test_schedule.id
        Rails.cache.delete(:cancel_load_test)
        self.end_time = Time.now
        break
      end

      optimal_runners_value = self.optimal_runners #Don't use directly, a bit of work in that method

      case
        when @runners.count < optimal_runners_value
          self.add_runners(optimal_runners_value - @runners.count)
        when @runners.count > optimal_runners_value
          self.stop_runners(@runners.count - optimal_runners_value)
      end

      #Every 30 second, update/prune results
      if time_difference % 30 == 0
        data_collection = self.pull_data
        self.save_data(data_collection)
      end

      sleep(1)
    end

    self.stop_runners(@runners.count)

    data_collection = self.collect_data
    self.save_data(data_collection)

    @former_runners = nil
    @runners = nil
  end

  def optimal_runners
    current_seconds_in = Time.now - self.start_time
    data_seconds_in = 0
    previous_max_users = 0

    @load_test_schedules.each { |load_test_schedule|
      schedule_duration = load_test_schedule.duration * 60

      #Skip if we already already past that in the data
      if (schedule_duration + data_seconds_in) <= current_seconds_in
        data_seconds_in += schedule_duration #Add it in so we skip it later
        previous_max_users = load_test_schedule.maximum_virtual_users
        next
      end

      #Create simple linear array to get current optimal users
      #Y is users, X is time

      ys = [previous_max_users, load_test_schedule.maximum_virtual_users]
      xs = [data_seconds_in, (data_seconds_in + schedule_duration)]

      data_seconds_in += schedule_duration #Add it in so we skip it later
      previous_max_users = load_test_schedule.maximum_virtual_users

      linear_object = Helpers::SimpleLinearRegression.new(xs, ys)
      return (linear_object.y(current_seconds_in)).ceil #Always round up
    }
  end
end