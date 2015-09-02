ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  
  
  def self.it_requires_authentication(&block)
    test "requires authentication" do
      session[:user_id] = nil
      instance_exec(&block)
      assert_redirected_to log_out_path
    end
  end

  def self.it_requires_owner(&block)
   test "requires user with role of owner" do
      user = FactoryGirl.build(:user, role: 2)
      session[:user_id] = user.id
      instance_exec(&block)      
      assert_redirected_to log_out_path
    end
  end


end
