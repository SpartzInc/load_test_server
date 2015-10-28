json.array!(@test_results) do |test_result|
  json.extract! test_result, :id, :test_schedule_id, :in_progress
  json.url test_result_url(test_result, format: :json)
end
