require 'test_helper'

class SpecrevisionsControllerTest < ActionController::TestCase

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


#show
#  test "should get show" do
#    sign_in users(:employee_2)

#    get :show, id: @project
#    assert_response :success

#    assert_not_nil assigns(:revisions)
#    assert_not_nil assigns(:subsections)
#    assert_not_nil assigns(:subsection)
#  end


#show_tab_content
#  test "should get content for tab" do
#    sign_in users(:employee_2)

#    get :show_tab_content, id: @project, subsection_id: ????
#    assert_response :success
#  end

end