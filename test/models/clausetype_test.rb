require 'test_helper'

class ClausetypeTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clausetype = Clausetype.new
     assert_respond_to(clausetype, :clauserefs)
     assert_respond_to(clausetype, :lineclausetypes)
     assert_respond_to(clausetype, :subsections)
   end
end