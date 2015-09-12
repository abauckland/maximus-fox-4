require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
  end

#index
  test "not authenticated should get redirect" do
    get :index
    assert_response :redirect
  end

  test "should list projects" do
    sign_in users(:owner)

    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end


#new
  test "should show new project" do
    sign_in users(:owner)

    get :new
    assert_response :success
  end

#create
  test "should create project" do
    sign_in users(:owner)

    assert_difference('Project.count') do
      post :create, project: { code: @project.code, title: @project.title, parent_id: @project.parent_id, company_id: 2, project_status: @project.project_status, ref_system: @project.ref_system, project_image: @project.project_image, client_name: @project.client_name, client_logo: @project.client_logo}
    end

    assert_redirected_to specification_path(assigns(:project))
    assert_equal "Project was successfully created.", flash[:notice]
  end

#edit
#  test "if user project role is not manage should redirect" do
#    sign_in users(:employee_2)

#    get :edit, id: @project
#    assert_response 403
#  end

  test "should show project edit" do
    sign_in users(:owner)

    get :edit, id: @project
    assert_response :success
    assert_not_nil assigns(:template)
    assert_not_nil assigns(:templates)
    assert_not_nil assigns(:available_status_array)
  end

#update
  test "should update project" do
    sign_in users(:owner)
    patch :update, id: @project, project: { code: @project.code, title: @project.title, parent_id: @project.parent_id, company_id: @project.company_id, project_status: @project.project_status, ref_system: @project.ref_system, project_image: @project.project_image, client_name: @project.client_name, client_logo: @project.client_logo }
    assert_redirected_to edit_project_path(assigns(:project))
    assert_equal "Project details have been updated", flash[:notice]
  end

end
