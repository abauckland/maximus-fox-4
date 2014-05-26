require 'test_helper'

class IdenttxtTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     identtxt =Identtxt.new
     assert_respond_to(identtxt, :identvalues)
   end
end
