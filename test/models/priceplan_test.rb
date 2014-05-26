require 'test_helper'

class PriceplanTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     priceplan = Priceplan.new
     assert_respond_to(priceplan, :planfeatures)
   end
end
