require 'test_helper'

class Txt3Test < ActiveSupport::TestCase
   test "should have associations" do
     txt3 = Txt3.new
     assert_respond_to(txt3, :speclines)
     assert_respond_to(txt3, :alterations)
   end
end
