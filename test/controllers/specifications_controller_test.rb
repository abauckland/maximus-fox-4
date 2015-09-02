require 'test_helper'

class SpecificationsControllerTest < ActionController::TestCase
  setup do
    @specline = speclines(:one) #set up dependencies - txt1, txt2, txt3, txt4, txt5, txt6, linetype, clause, clauseref, clausetitle
    @project = projects(:one)
    @subsection = subsection(:one) #!???????
    @clausetype = clausetypes(:one)
  end

#empty_project

#  test "should get empty project" do
#    get :empty_project, id: @project
#    assert_response :success
#  end



#show

#  test "should get show" do
#    get :show, id: @project
#    assert_response :success
#  end



#show_tab_content

#  test "should get content for tab" do
#    get :show_tab_content, id: @project, subsection_id: ????, clausetype_id: ????
#    assert_response :success
#  end

end