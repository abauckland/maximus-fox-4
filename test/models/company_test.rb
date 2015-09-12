require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

#associations
   test "should be associated with users and identvalues" do
     company = Company.new
     assert_respond_to(company, :users)
     assert_respond_to(company, :projects)
     assert_respond_to(company, :identvalues)
   end

#vaildations
   test "should not save company without name" do
      company = Company.create(read_term: 1)
      assert_not company.valid?
   end

   test "should not save company without terms read" do
      company = Company.create(name: 'specright', read_term: 0)
      assert_not company.valid?
      assert_equal ["Please confirm you have read the terms and conditions"], company.errors.messages[:read_term]
   end

   test "should not save if duplicate name" do
      company = Company.create(name: 'specright', read_term: 1)
      assert_not company.valid?
      assert_equal ["An account for a company with the same name already exists, please contact us for details"], company.errors.messages[:name]
   end

   test "should not save company when company name length short" do
      company = Company.create(name: 'sp', read_term: 1)
      assert_not company.valid?
      assert_equal ["is too short (minimum is 3 characters)"], company.errors.messages[:name]
   end

   test "should not save if name contain no alphanumeric characters" do
      company = Company.create(name: 'spec$', read_term: 1)
      assert_not company.valid?
      assert_equal ["please enter a valid name"], company.errors.messages[:name]
   end

   test "should not save company" do
      company = Company.create(name: 'specright2', read_term: 1)
      assert company.valid?
   end

   #check_field added to filter out sign up attempts by spambots - throws false message
#   test "should not save company when check field has value" do
#      company = FactoryGirl.build(:company, check_field: "mystring")
#      assert_not company.valid?
#      assert_equal ["Cannot be blank"], company.errors.messages[:check_field]
#   end

#methods
   test "should combined company details" do
      company = companies(:specright)
      assert_equal "specright, Tel: 0161 274 2800, Web: specright.co.uk.", company.details
   end

   
   #validate attachments

end
