require 'test_helper'

class ClauseguideTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clauseguide = Clauseguide.new
     assert_respond_to(clauseguide, :clause)
     assert_respond_to(clauseguide, :guidenote)
   end

#methods
   test "should return clause code" do
      clauseguide = clauseguides(:one)
      assert_equal "1110 title_1", clauseguide.clause_title
   end

end
