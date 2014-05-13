json.array!(@revisions) do |revision|
  json.extract! revision, :id, :rev, :project_status, :project_id, :user_id, :date
  json.url revision_url(revision, format: :json)
end
