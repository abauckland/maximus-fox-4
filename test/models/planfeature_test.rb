require 'test_helper'

class PlanfeatureTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     planfeature = Planfeature.new
     assert_respond_to(planfeature, :priceplan)
   end
end
