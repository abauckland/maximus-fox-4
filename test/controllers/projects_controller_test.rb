require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:projects)
#  end#

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should create project" do
#    assert_difference('Project.count') do
#      post :create, project: { code: @project.code, company_id: @project.company_id, logo_path: @project.logo_path, parent_id: @project.parent_id, ref_system: @project.ref_system, photo_content_type: @project.photo_content_type, photo_file_name: @project.photo_file_name, photo_file_size: @project.photo_file_size, photo_updated_at: @project.photo_updated_at, project_status: @project.project_status, title: @project.title }
#    end

#    assert_redirected_to project_path(assigns(:project))
#  end

#  test "should show empty project" do
#    get :empty_project, id: @project
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, id: @project
#    assert_response :success
#  end

#  test "should update project" do
#    patch :update, id: @project, project: { code: @project.code, company_id: @project.company_id, logo_path: @project.logo_path, parent_id: @project.status, ref_system: @project.ref_system, photo_content_type: @project.photo_content_type, photo_file_name: @project.photo_file_name, photo_file_size: @project.photo_file_size, photo_updated_at: @project.photo_updated_at, project_status: @project.project_status, title: @project.title }
#    assert_redirected_to project_path(assigns(:project))
#  end

end
