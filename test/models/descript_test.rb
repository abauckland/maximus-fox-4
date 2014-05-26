require 'test_helper'

class DescriptTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     descript = Descript.new
     assert_respond_to(descript, :product)
     assert_respond_to(descript, :identity)
   end
end
