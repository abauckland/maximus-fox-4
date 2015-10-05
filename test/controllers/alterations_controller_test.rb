require 'test_helper'

class AlterationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

#clause_change_info
  test "should show clause edit info" do
    sign_in users(:employee_2)
    xhr :get, :clause_change_info, format: :js, id: 2, rev_id: 2, clause_id: 22
    assert_response :success
  end


#line_change_info
  test "should show line edit info" do
    sign_in users(:employee_2)
    xhr :get, :line_change_info, format: :js, id: 14
    assert_response :success
  end


#print_setting
#  test "should post my action" do
#    post :my_action, { 'param' => "value" }, :format => "json"
#    assert_response :success
#    body = JSON.parse(response.body)
#    assert_equal "Some returned value", body["str"]
#  end


end
