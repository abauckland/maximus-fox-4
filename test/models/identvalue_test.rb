require 'test_helper'

class IdentvalueTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     identvalue = Identvalue.new
     assert_respond_to(identvalue, :identities)
     assert_respond_to(identvalue, :identtxt)
     assert_respond_to(identvalue, :company)
   end
end
