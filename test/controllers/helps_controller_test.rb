require 'test_helper'

class HelpsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    #  @help = Help.create! :item => 'Test Title', :text => 'Test body'
    @help = helps(:one)
  end

#index
  test "not authenticated should get redirect" do
    get :index
    assert_response :redirect
  end

  test "if user role is not admin should get redirect" do
    sign_in users(:owner)

    get :index
    assert_response 403
  end


  test "if user role is admin should get index" do
    sign_in users(:admin)

    get :index
#   assert_template :index #must be explicitly stated in action
#   assert_template layout: "layouts/administrations" #must be explicitly stated in action

    assert_response :success
    assert_not_nil assigns(:helps)

    # admin users can create, delete and edit options
#    assert_select ".title_button", count: 1 #link to create new record
#    assert_select ".line_edit_icon", count: 3 #number of fixtures
#    assert_select ".line_delete_icon", count: 3 #number of fixtures
  end




#show
#TODO returns text as json to js view
#  test "should show help" do
#    get :show, id: @help
#    assert_response :success
#  end

#test "return text via javascript" do
  # use xhr to simulate a ajax call
#  xhr :get, :show, format: :js, product_id: '77'
  # if the controller responds with a javascript file the response will be a success
#  assert_response :success
#end


  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end


  test "should create help" do
    sign_in users(:admin)
    assert_difference('Help.count') do
      post :create, help: {:item => 'Test Title', :text => 'Test body'}
    end
    #redirect to index if saved
    assert_redirected_to helps_path
  end


  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @help
    assert_response :success
  end


  test "should update post" do
    sign_in users(:admin)
    patch :update, id: @help, help: { item: @help.item, text: @help.text }

    #redirect to index if updated
    assert_redirected_to helps_path
  end


  test "should destroy help" do
    sign_in users(:admin)
    assert_difference('Help.count', -1) do
      delete :destroy, id: @help
    end

    assert_redirected_to helps_path
  end


end
