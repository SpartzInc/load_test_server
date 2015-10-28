json.array!(@custom_hosts) do |custom_host|
  json.extract! custom_host, :id
  json.url custom_host_url(custom_host, format: :json)
end
