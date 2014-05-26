require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     project = FactoryGirl.build_stubbed(:project)
     assert_respond_to(project, :projectusers)
     assert_respond_to(project, :users)
     assert_respond_to(project, :speclines)
     assert_respond_to(project, :clauses)
     assert_respond_to(project, :revisions)
     assert_respond_to(project, :alterations)
     assert_respond_to(project, :printsettings)
   end

#vaildations 
   test "should not save project without code" do
      project = FactoryGirl.build(:project, code: "")
      assert_not project.valid?
   end

   test "should not save project without title" do
      project = FactoryGirl.build(:project, title: "")
      assert_not project.valid?
   end

#methods
   test "should combined code and title" do
      project = FactoryGirl.build(:project)
      assert_equal "P11 project title 1", project.code_and_title
   end

#scopes
  test "should return parent project (references self)" do 
      project = FactoryGirl.create(:project)      
      assert_equal project, Project.project_template(project)
   end



   #validate attachments
   #validate presence of photo
   
end
