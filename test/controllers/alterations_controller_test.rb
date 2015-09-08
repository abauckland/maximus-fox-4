require 'test_helper'

class AlterationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

#  setup do
#    @alteration_line = alterations(:line)
#    @alteration_clause = alterations(:clause)
#  end

#index
#  test "not authenticated should get redirect" do
#    get :index
#    assert_response :redirect
#  end

#  test "if user role is not admin should get redirect" do
#    sign_in users(:manage)

#    get :index
#    assert_response 403
#  end


#clause_change_info
#  test "should show clause edit info" do
#    sign_in users(:manage)

#    get :edit, id: @alteration_clause
#    assert_response :success
#  end


#line_change_info
#  test "should show line edit info" do
#    sign_in users(:manage)

#    get :edit, id: @alteration_line
#    assert_response :success
#  end


#print_setting

end
