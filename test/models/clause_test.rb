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
   test "should return clause code" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "A10.1110", clause.clause_code
   end


   test "should return clauseref code" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "1110", clause.clauseref_code
   end

   test "should return clauseref code and title" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "title_1", clause.clause_title
   end

   test "should return caws code" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "A10.1110", clause.caws_code
   end

   test "should return full caws code and title" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "A10.1110 title_1", clause.caws_full_title
   end

   test "should return part caws code and title" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "scope 1110: title_1", clause.part_ref_title
   end

   test "should return title in brackets" do
      clause = clauses(:CAWS_A10_1110_title_1)
      assert_equal "(title_1)", clause.clause_code_title_in_brackets
   end

end
