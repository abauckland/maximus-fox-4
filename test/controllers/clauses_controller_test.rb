require 'test_helper'

class ClausesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

#  setup do
#    @clause = clauses(:one)
#  end

#authorization
#  test "not authenticated should get redirect" do
#    get :new
#    assert_response :redirect
#  end

#  test "if user role is read should get redirect" do
#    sign_in users(:employee_2)

#    get :new
#    assert_response 403
#  end


#new
#  test "should show form" do
#    sign_in users(:edit)

#    get :new, id: @project.id, subsection_id: ????
#    assert_response :success
#  end


#create
#  test "should create clause" do
#    sign_in users(:edit)

#    assert_difference('Specline.count') do
#      post :create, id: @project.id, revision_id: @project.revision_id, template_clauses: [1,2]
#    end

#    #redirect to index if saved
#    assert_redirected_to manage_specclause_path(id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id)
#  end

#  test "should create clause and record alteration" do
#    sign_in users(:edit)
#  end


#new_clone_project_list
#  test "should list projects" do
#    sign_in users(:edit)
#  end


#new_clone_subsection_list
#  test "should list subsections" do
#    sign_in users(:edit)
#  end


#new_clone_clause_list
#  test "should list clauses" do
#    sign_in users(:edit)
#  end


end
