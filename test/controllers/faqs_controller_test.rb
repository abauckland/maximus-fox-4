require 'test_helper'

class FaqsControllerTest < ActionController::TestCase
  setup do
    @faq = FactoryGirl.build_stubbed(:faq)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faqs)
  end

end
