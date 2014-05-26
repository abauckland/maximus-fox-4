require 'test_helper'

class CharcTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     charc = Charc.new
     assert_respond_to(charc, :instance)
     assert_respond_to(charc, :perform)
   end
end