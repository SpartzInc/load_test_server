json.array!(@load_tests) do |load_test|
  json.extract! load_test, :id, :user_scenario_id, :name
  json.url load_test_url(load_test, format: :json)
end
