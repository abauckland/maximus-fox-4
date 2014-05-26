require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

#associations
   test "should be associated with users and identvalues" do
     company = FactoryGirl.build_stubbed(:company) 
     assert_respond_to(company, :users)
     assert_respond_to(company, :identvalues)
   end

#vaildations     
   test "should not save company without name" do
      company = FactoryGirl.build(:company, name: "")
      assert_not company.valid?
   end
   
   test "should not save company without terms read" do
      company = FactoryGirl.build(:company, read_term: 0)
      assert_not company.valid?
   end

   #check_field added to filter out sign up attempts by spambots - throws false message
   test "should not save company when check field has value" do
      company = FactoryGirl.build(:company, check_field: "mystring")
      assert_not company.valid?
      assert_equal ["Cannot be blank"], company.errors.messages[:check_field]
   end

   test "should not save company when company name length short" do
      company = FactoryGirl.build(:company, name: "my")
      assert_not company.valid?
      assert_equal ["is too short (minimum is 3 characters)"], company.errors.messages[:name]
   end

   test "should not save company when company name not unique" do
      company = FactoryGirl.build(:company) 
      company_copy = company.dup
      company.save
      company_copy.save
      
      assert_not company_copy.valid?
      assert_equal ["An account for the company already exists, please contact your administrator or us for details"], company_copy.errors.messages[:name]
   end

#methods
   test "should combined company details" do
      company = FactoryGirl.build(:company)
      assert_equal "company name 2, Tel: 0161 274 4613, Web: website.co.uk.", company.details
   end

   
   #validate attachments

end
