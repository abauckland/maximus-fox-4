require 'test_helper'

class ClauserefTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clauseref = Clauseref.new
     assert_respond_to(clauseref, :subsection)
     assert_respond_to(clauseref, :clausetype)
     assert_respond_to(clauseref, :clauses)
   end



end
