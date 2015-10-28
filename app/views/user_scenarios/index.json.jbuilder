json.array!(@user_scenarios) do |user_scenario|
  json.extract! user_scenario, :id, :name
  json.url user_scenario_url(user_scenario, format: :json)
end
