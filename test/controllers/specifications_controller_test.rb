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