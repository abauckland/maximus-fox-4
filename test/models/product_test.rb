require 'test_helper'

class ProductTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     product = Product.new
     assert_respond_to(product, :clauseproducts)
     assert_respond_to(product, :descripts)
     assert_respond_to(product, :identities)
     assert_respond_to(product, :instances)
     assert_respond_to(product, :producttype)
   end
end