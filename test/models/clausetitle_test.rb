require 'test_helper'

class ClausetitleTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clausetitle = Clausetitle.new
     assert_respond_to(clausetitle, :clauses)
   end
end
