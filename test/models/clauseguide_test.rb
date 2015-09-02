require 'test_helper'

class ClauseguideTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clauseguide = Clauseguide.new
     assert_respond_to(clauseguide, :clause)
     assert_respond_to(clauseguide, :guidenote)
   end
end
