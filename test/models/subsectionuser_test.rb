require 'test_helper'

class SubsectionuserTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     subsectionuser = Subsectionuser.new
     assert_respond_to(subsectionuser, :projectuser)
     assert_respond_to(subsectionuser, :subsection)
   end
end