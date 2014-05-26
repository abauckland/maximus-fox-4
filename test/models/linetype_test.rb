require 'test_helper'

class LinetypeTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     linetype = Linetype.new
     assert_respond_to(linetype, :speclines)
     assert_respond_to(linetype, :alterations)
     assert_respond_to(linetype, :lineclausetypes)
   end
end
