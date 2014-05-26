require 'test_helper'

class Txt5Test < ActiveSupport::TestCase
   test "should have associations" do
     txt5 = Txt5.new
     assert_respond_to(txt5, :speclines)
     assert_respond_to(txt5, :alterations)
   end
end
