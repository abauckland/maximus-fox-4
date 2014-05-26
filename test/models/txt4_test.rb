require 'test_helper'

class Txt4Test < ActiveSupport::TestCase
   test "should have associations" do
     txt4 = Txt4.new
     assert_respond_to(txt4, :speclines)
     assert_respond_to(txt4, :alterations)
   end
end
