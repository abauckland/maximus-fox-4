json.array!(@projectusers) do |projectuser|
  json.extract! projectuser, :id, :user_id, :project_id
  json.url projectuser_url(projectuser, format: :json)
end
