require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     project = Project.new
     assert_respond_to(project, :projectusers)
     assert_respond_to(project, :users)
     assert_respond_to(project, :speclines)
     assert_respond_to(project, :clauses)
     assert_respond_to(project, :revisions)
     assert_respond_to(project, :alterations)
     assert_respond_to(project, :printsetting)
     assert_respond_to(project, :prints)
   end

#mounted uploaders

#vaildations 
   test "should not save project without code" do
      project = Project.create( title: 'Test Project' )
      assert_not project.valid?, 'Should not create project without code', project.errors.messages[:code]
   end

   test "should not save project without title" do
      project = Project.create( code: 'T-0001' )
      assert_not project.valid?, 'Should not create project without title', project.errors.messages[:title]
   end

   test "should not save project with duplicate title and code" do
    project = Project.create( code: 'T-0001', title: 'Test Project', company_id: 1 )
    project_copy = Project.create( code: 'T-0001', title: 'Test Project', company_id: 1 )

    assert_not project_copy.valid?, 'The project should not be valid an existing record with the same item name exists', project.errors.messages[:code]
   end


#methods
   test "should combined code and title" do
      project = projects(:CAWS_template)
      assert_equal "S-001 CAWS Template Project", project.code_and_title
   end

#scopes
#  test "should return parent project (references self)" do 
#      project = projects(:CAWS_template)      
#      assert_equal project, Project.project_template(project)
#   end
   
end
