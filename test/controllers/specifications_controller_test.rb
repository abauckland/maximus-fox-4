require 'test_helper'

class SpecificationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
#    @specline = speclines(:one) #set up dependencies - txt1, txt2, txt3, txt4, txt5, txt6, linetype, clause, clauseref, clausetitle
    @project = projects(:CAWS)
#    @subsection = subsection(:one) #!???????
#    @clausetype = clausetypes(:one)
  end

#authorization
  test "not authenticated should get redirect" do
    get :show, id: @project
    assert_response :redirect
  end

#empty_project

#  test "should get empty project" do
#    sign_in users(:employee_2)

#    get :empty_project, id: @project
#    assert_response :success
#  end



#show
#  test "should get show" do
#    sign_in users(:employee_2)

#    get :show, id: @project
#    assert_response :success

#    assert_not_nil assigns(:subsections)
#    assert_not_nil assigns(:revision)
#  end


#show_tab_content
#  test "should get content for tab" do
#    sign_in users(:employee_2)

#    get :show_tab_content, id: @project, subsection_id: ????, clausetype_id: ????
#    assert_response :success
#  end

end