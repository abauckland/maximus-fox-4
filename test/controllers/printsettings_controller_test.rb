require 'test_helper'

class PrintsettingsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

#  setup do
#    @project = projects(:CAWS_template)
#    @printsetting = printsettings(:one)
#  end

#index
#  test "not authenticated should get redirect" do
#    get :index
#    assert_response :redirect
#  end

#  test "if user role is not manager should get redirect" do
#    sign_in users(:edit)

#    get :index
#    assert_response 403
#  end

#edit
#  test "if user role is manager show printsettings" do
#    sign_in users(:manage)

#    get :edit, id: @printsetting
#    assert_response :success

#  end


#update
#  test "should update printsettings" do
#    sign_in users(:manage)
      
#    patch :update, id: @printsetting, printsetting: {}

    #redirect to index if updated
#    assert_redirected_to edit_printsetting_path(@printsetting.project_id)
#  end

end
