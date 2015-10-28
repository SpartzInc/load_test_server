class TestJob < Struct.new(:test_schedule)
  def perform
    return if test_schedule.cancelled?

    #Initial data saving
    test_schedule.started = true
    test_schedule.start_time = Time.now
    test_schedule.save

    begin
      self.run_test_job(test_schedule)
    rescue Exception => e
      test_schedule.failed = true
      test_schedule.failed_message = e.to_s + ' '
      test_schedule.failed_message += e.backtrace_locations.to_s
    end

    test_schedule.complete = true
    test_schedule.end_time = Time.now
    test_schedule.save
  end

  def run_test_job(test_schedule)
    test_result = TestResult.new
    test_result.test_schedule = test_schedule
    test_result.in_progress = true
    test_result.save

    #Run the test
    load_test = test_schedule.load_test

    test_arguments = {
        :test_result => test_result,
        :test_schedule => test_schedule,
        :load_test_schedules => load_test.load_test_schedules,
        :steps => load_test.user_scenario.user_scenario_steps
    }

    puts 'Starting RunningMan'.colorize(:green)

    runner = RunningMan.new(test_arguments)
    runner.run

    runner = nil
    puts 'Finished RunningMan'.colorize(:red)

    #Add EC2/RDS Metrics if needed
    self.add_aws_ec2_instances(load_test, test_result)
    self.add_aws_rds_instances(load_test, test_result)

    test_result.in_progress = false
    test_result.save
  end

  def add_aws_ec2_instances(load_test, test_result)
    load_test.load_test_aws_ec2_instances.each { |load_test_aws_ec2_instances|

      test_result_aws_ec2_instance = TestResultAwsEc2Instance.new
      test_result_aws_ec2_instance.test_result = test_result
      test_result_aws_ec2_instance.aws_ec2_instance = load_test_aws_ec2_instances.aws_ec2_instance
      test_result_aws_ec2_instance.metric = load_test_aws_ec2_instances.metric
      test_result_aws_ec2_instance.start_time = test_result.test_schedule.start_time
      test_result_aws_ec2_instance.end_time = Time.now
      test_result_aws_ec2_instance.save
    }
  end

  def add_aws_rds_instances(load_test, test_result)
    load_test.load_test_aws_rds_instances.each { |load_test_aws_rds_instance|
      test_result_aws_rds_instance = TestResultAwsRdsInstance.new
      test_result_aws_rds_instance.test_result = test_result
      test_result_aws_rds_instance.aws_rds_instance = load_test_aws_rds_instance.aws_rds_instance
      test_result_aws_rds_instance.metric = load_test_aws_rds_instance.metric
      test_result_aws_rds_instance.start_time = test_result.test_schedule.start_time
      test_result_aws_rds_instance.end_time = Time.now
      test_result_aws_rds_instance.save
    }
  end

  def max_attempts
    1
  end
end