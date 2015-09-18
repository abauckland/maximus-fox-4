require 'test_helper'

class SpecclausesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
    @subsection = subsections(:CAWS_A10)
  end

#authorization
  test "not authenticated should get redirect" do
    get :manage, id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id
    assert_response :redirect
  end

#  test "if user role is read should get redirect" do
#    sign_in users(:employee_2)

#    get :manage, id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id
#    assert_response 403
#  end

#manage
  test "should show project and template clauses" do
    sign_in users(:owner)

    get :manage, id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id
    assert_response :success

    assert_not_nil assigns(:template)
    assert_not_nil assigns(:templates)
    assert_not_nil assigns(:current_project_clauses)
    assert_not_nil assigns(:template_project_clauses)
  end


#add_clauses
#  test "should add clauses" do
#    sign_in users(:manage)

#    assert_difference('Specline.count') do
#      post :add_clauses, id: @project.id, revision_id: @project.revision_id, template_clauses: [1,2]
#    end

#    #redirect to index if saved
#    assert_redirected_to manage_specclause_path(id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id)
#  end


#delete_clauses
  test "should remove subsections" do
    sign_in users(:owner)

    assert_difference('Specline.count', -6) do
      put :delete_clauses, id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id, project_clauses: [13,14]
    end

    #redirect to index if saved
    assert_redirected_to manage_specclause_path(id: @project.id, template_id: @project.parent_id, subsection_id: @subsection.id)
  end

end