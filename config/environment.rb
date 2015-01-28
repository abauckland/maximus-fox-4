# Load the Rails application.
require File.expand_path('../application', __FILE__)
ActionMailer::Base.delivery_method = :smtp
# Initialize the Rails application.
Rails.application.initialize!
