require 'test_helper'

class AboutsControllerTest < ActionController::TestCase
  setup do
    @about = FactoryGirl.build_stubbed(:about)
  end

  test "should get index" do
    get :index
    assert_response :success
    
    #assigns to @contents and not @abouts due to requirement
    #for standard variable passed to partial used in a number of different view
    assert_not_nil assigns(:contents)
  end

end
