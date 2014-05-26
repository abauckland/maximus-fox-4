require 'test_helper'

class IdentkeyTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     identkey = Identkey.new
     assert_respond_to(identkey, :identities)
   end
end
