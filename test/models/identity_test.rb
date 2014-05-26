require 'test_helper'

class IdentityTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     identity = Identity.new
     assert_respond_to(identity, :descripts)
     assert_respond_to(identity, :products)
     assert_respond_to(identity, :speclines)
     assert_respond_to(identity, :alteravtions)
     assert_respond_to(identity, :identvalue)
     assert_respond_to(identity, :identkey)          
   end
end
