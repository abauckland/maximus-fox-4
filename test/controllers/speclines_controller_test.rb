require 'test_helper'

class SpeclinesControllerTest < ActionController::TestCase
  setup do
    @specline = speclines(:one)
  end

 

  test "should get edit" do
    get :edit, id: @specline
    assert_response :success
  end

  test "should update specline" do
    patch :update, id: @specline, specline: { clause_id: @specline.clause_id, clause_line: @specline.clause_line, identity_id: @specline.identity_id, linetype_id: @specline.linetype_id, perform_id: @specline.perform_id, project_id: @specline.project_id, txt1_id: @specline.txt1_id, txt2_id: @specline.txt2_id, txt3_id: @specline.txt3_id, txt4_id: @specline.txt4_id, txt5_id: @specline.txt5_id, txt6_id: @specline.txt6_id }
    assert_redirected_to specline_path(assigns(:specline))
  end

  test "should destroy specline" do
    assert_difference('Specline.count', -1) do
      delete :delete_specline, id: @specline
    end

    assert_redirected_to speclines_path
  end
end
