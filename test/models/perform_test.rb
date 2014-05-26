require 'test_helper'

class PerformTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     perform = Perform.new
     assert_respond_to(perform, :charcs)
     assert_respond_to(perform, :instances)
     assert_respond_to(perform, :speclines)
     assert_respond_to(perform, :alterations)
     assert_respond_to(perform, :performkey)
     assert_respond_to(perform, :performvalue)         
   end
end
