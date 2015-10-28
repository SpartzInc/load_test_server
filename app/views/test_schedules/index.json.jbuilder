json.array!(@test_schedules) do |test_schedule|
  json.extract! test_schedule, :id, :load_test_id, :schedule_now, :schedule_at, :started, :complete
  json.url test_schedule_url(test_schedule, format: :json)
end
