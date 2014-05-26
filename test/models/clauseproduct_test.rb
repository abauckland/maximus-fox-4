require 'test_helper'

class ClauseproductTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clauseproduct = Clauseproduct.new
     assert_respond_to(clauseproduct, :clause)
     assert_respond_to(clauseproduct, :product)
   end
end
