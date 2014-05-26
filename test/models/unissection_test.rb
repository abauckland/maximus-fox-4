require 'test_helper'

class UnissectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     unisection = Unissection.new
     assert_respond_to(unisection, :unisubsections)
   end
end
