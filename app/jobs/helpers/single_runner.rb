#SingleRunner class that does the work of a single user
class Helpers::SingleRunner
  attr_accessor :steps, :steps_data, :running, :thread, :stop_thread

  def initialize(args)
    self.steps = args.fetch :steps
    self.running = false

    @data_mutex = Mutex.new
  end

  def steps_data
    return @steps_data if @steps_data

    @steps_data = {
        :response_times => [],
        :response_codes => []
    }

    return @steps_data
  end

  def pull_data(data_key)
    @data_mutex.synchronize do
      data = self.steps_data[data_key].clone
      self.steps_data[data_key] = []
      return data
    end
  end

  def push_data(data_key, data)
    @data_mutex.synchronize do
      self.steps_data[data_key].push(data)
    end
  end

  def start
    puts "RunningMan Single Runner: Starting".colorize(:blue)
    self.running = true

    #Thread.abort_on_exception = true
    self.thread = Thread.new {
      puts "RunningMan Single Runner: Starting Thread".colorize(:magenta)

      until self.stop_thread
        start_time = Time.now.to_f
        break if self.stop_thread

        #Run the steps
        self.run_steps

        time_difference = Time.now.to_f - start_time
        sleep(1-time_difference) if time_difference < 1 and time_difference > 0
      end

      puts 'Thread Complete'.colorize(:magenta)
      self.running = false
    }
  end

  def stop
    self.stop_thread = true
  end

  def run_steps
    start_time = Time.now

    self.steps.each { |step|
      request_url = step.request_url
      request_type = step.request_type.downcase.to_sym

      params = {}
      step.scenario_step_request_params.each { |param|
        params[param.request_key.to_sym] = param.request_value
      }

      RestClient.send(request_type, request_url, {:params => params}) { |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)
        end

        self.push_data(:response_codes, {:time => start_time, :response_code => response.code})
      }
    }

    #Add response time, start_time is x, response time y
    response_time = Time.now.to_f - start_time.to_f
    self.push_data(:response_times, {:time => start_time, :response_time => response_time})
  end
end