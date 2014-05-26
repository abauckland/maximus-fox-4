require 'test_helper'

class ProjectuserTest < ActiveSupport::TestCase
#associations
   test "should be associated with projects, users, subsectionusers, subsections" do
     projectuser = Projectuser.new
     assert_respond_to(projectuser, :project)
     assert_respond_to(projectuser, :user)
     assert_respond_to(projectuser, :subsectionusers)
     assert_respond_to(projectuser, :subsections)
   end
end
