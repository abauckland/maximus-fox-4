json.array!(@users) do |user|
  json.extract! user, :id, :company_id, :first_name, :surname, :email, :role, :api_key, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at
  json.url user_url(user, format: :json)
end
