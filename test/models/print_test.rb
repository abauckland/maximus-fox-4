require 'test_helper'

class PrintTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     print = Print.new
     assert_respond_to(print, :project)
     assert_respond_to(print, :revision)
     assert_respond_to(print, :user)
   end

end