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
     assert_respond_to(project, :printsettings)
#     assert_respond_to(project, :prints)
   end

#mounted uploaders

#vaildations 
   test "should not save without code" do
      project = Project.create( title: 'Test Project', company_id: 1, parent_id: 1)
      assert_not project.valid?, 'Should not create project without code'
   end

   test "should not save without title" do
      project = Project.create( code: 'T-0001', company_id: 1, parent_id: 1)
      assert_not project.valid?, 'Should not create project without title'
   end

   test "should not save duplicate" do
    project = Project.create( code: 'T-0001', title: 'Test Project', company_id: 1, parent_id: 1)
    project_copy = Project.create( code: 'T-0001', title: 'Test Project', company_id: 1, parent_id: 1)

    assert_not project_copy.valid?, 'The project should not be valid an existing record with the same item name exists'
   end


#methods
   test "should combined code and title" do
      project = projects(:CAWS)
      assert_equal "S-001 CAWS Project", project.code_and_title
   end

#scopes
   test "should return parent project (references self)" do 
      project = projects(:CAWS)
      assert_equal project, Project.project_template(project)
   end

#   test "should return list of projects" do 
#      project_1 = projects(:CAWS)
#      project_2 = projects(:CAWS_rev)
#      project_3 = projects(:CAWS_template)
#      user = users(:admin)
#      assert_equal [project_1, project_2, project_3], Project.user_projects(user)
#   end


end
