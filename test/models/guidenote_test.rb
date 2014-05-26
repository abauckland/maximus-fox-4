require 'test_helper'

class GuidenoteTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     guidenote = Guidenote.new
     assert_respond_to(guidenote, :clauses)
   end
end
