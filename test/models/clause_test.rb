require 'test_helper'

class ClauseTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     clause = Clause.new
     assert_respond_to(clause, :speclines)
     assert_respond_to(clause, :projects)
     assert_respond_to(clause, :alterations)
     assert_respond_to(clause, :clauseproducts)
     assert_respond_to(clause, :products)
     assert_respond_to(clause, :clauseref)
     assert_respond_to(clause, :clausetitle)
     assert_respond_to(clause, :clauseguides)                              
   end

#assign title
#TODO

#custom validation
#TODO

#methods
   test "should return clauseref code" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "1110", clause.clauseref_code
   end

end
