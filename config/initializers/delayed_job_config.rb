Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 1
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.sleep_delay = 5