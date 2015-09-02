require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS_template)
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


#edit
  test "if user project role is not manage should redirect" do
    sign_in users(:employee_2)

    get :edit, id: @project
    assert_response 403
  end

  test "should show project edit" do
    sign_in users(:owner)

    get :edit, id: @project
    assert_response :success
    assert_not_nil assigns(:templates)
    assert_not_nil assigns(:template)
    assert_not_nil assigns(:available_status_array)
  end

#update

#  test "should create project" do
#    assert_difference('Project.count') do
#      post :create, project: { code: @project.code, company_id: @project.company_id, logo_path: @project.logo_path, parent_id: @project.parent_id, ref_system: @project.ref_system, photo_content_type: @project.photo_content_type, photo_file_name: @project.photo_file_name, photo_file_size: @project.photo_file_size, photo_updated_at: @project.photo_updated_at, project_status: @project.project_status, title: @project.title }
#    end

#    assert_redirected_to project_path(assigns(:project))
#  end


#  test "should update project" do
#    patch :update, id: @project, project: { code: @project.code, company_id: @project.company_id, logo_path: @project.logo_path, parent_id: @project.status, ref_system: @project.ref_system, photo_content_type: @project.photo_content_type, photo_file_name: @project.photo_file_name, photo_file_size: @project.photo_file_size, photo_updated_at: @project.photo_updated_at, project_status: @project.project_status, title: @project.title }
#    assert_redirected_to project_path(assigns(:project))
#  end

end
