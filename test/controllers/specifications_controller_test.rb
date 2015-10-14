require 'test_helper'

class SpecificationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
#    @specline = speclines(:one) #set up dependencies - txt1, txt2, txt3, txt4, txt5, txt6, linetype, clause, clauseref, clausetitle
    @project = projects(:CAWS)
  end

#authorization
  test "not authenticated should get redirect" do
    get :show, id: @project
    assert_response :redirect
  end

#empty_project
  test "should get empty project" do
    sign_in users(:employee_2)

    get :empty_project, id: @project
    assert_response :success
  end



#show
  test "should get show" do
    sign_in users(:employee_2)

    get :show, id: @project
    assert_response :success

    assert_not_nil assigns(:project_subsections)
    assert_not_nil assigns(:clausetypes)
    assert_not_nil assigns(:current_clausetype)
    assert_not_nil assigns(:selected_subsection)
    assert_not_nil assigns(:selected_specline_lines)
    assert_not_nil assigns(:project)

    # admin users can create, delete and edit options
    assert_select "#primary_project",     count: 1
    assert_select "#sub_select_project",  count: 1
    assert_select "#sub_new_project",     count: 1
    assert_select "#sub_edit_project",    count: 1
    assert_select "#sub_project_users",   count: 0

    assert_select "#primary_document",    count: 1
    assert_select "#primary_revisions",   count: 1
    assert_select "#primary_publish",     count: 1
    assert_select "#sub_print",           count: 1
    assert_select "#sub_printsetting",    count: 1
    assert_select "#sub_keynote",         count: 1
    assert_select "#sub_data_export",     count: 0

    assert_select "#manage_section_link", count: 0

  end

  test "should get show for admin" do
    sign_in users(:admin)

    get :show, id: @project
    assert_response :success

    # admin users can create, delete and edit options
    assert_select "#primary_project",     count: 1
    assert_select "#sub_select_project",  count: 1
    assert_select "#sub_new_project",     count: 1
    assert_select "#sub_edit_project",    count: 1
    assert_select "#sub_project_users",   count: 1

    assert_select "#primary_document",    count: 1
    assert_select "#primary_revisions",   count: 1
    assert_select "#primary_publish",     count: 1
    assert_select "#sub_print",           count: 1
    assert_select "#sub_printsetting",    count: 1
    assert_select "#sub_keynote",         count: 1
    assert_select "#sub_data_export",     count: 1

    assert_select "#manage_section_link", count: 1
  end




#show_tab_content
  test "should get content for tab" do
    sign_in users(:employee_2)

    xhr :get, :show_tab_content, format: :js, id: @project, subsection_id: 1, clausetype_id: 2
    assert_response :success

    assert_not_nil assigns(:clausetype_id)
    assert_not_nil assigns(:selected_specline_lines)
  end

end