require 'test_helper'

class FaqsControllerTest < ActionController::TestCase
  setup do
    @faq = faqs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:faqs)
  end

end
