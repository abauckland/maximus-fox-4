require 'test_helper'

class PrintsettingsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
    @printsetting = printsettings(:CAWS_settings)
  end

#edit
  test "not authenticated should get redirect" do
    get :edit, id: @project
    assert_response :redirect
  end

#  test "if user role is not manager should get redirect" do
#    sign_in users(:employee_1)
#
#    get :edit, id: @project
#    assert_response 403
#  end

  test "if user role is manager show printsettings" do
    sign_in users(:owner)

    get :edit, id: @project
    assert_response :success
  end


#update
  test "should update printsettings" do
    sign_in users(:owner)

    patch :update, id: @project, printsetting: {
                          font_style: @printsetting.font_style, font_size: @printsetting.font_size, structure: @printsetting.structure,
                          prelim: @printsetting.prelim, page_number: @printsetting.page_number, client_detail: @printsetting.client_detail,
                          client_logo: @printsetting.client_logo, project_detail: @printsetting.project_detail, project_image: @printsetting.project_image,
                          company_detail: @printsetting.company_detail, header_project: @printsetting.header_project, header_client: @printsetting.header_client,
                          header_document: @printsetting.header_document, header_logo: @printsetting.header_logo, footer_detail: @printsetting.footer_detail,
                          footer_author: @printsetting.footer_author, footer_date: @printsetting.footer_date
                          }

    #redirect to index if updated
    assert_redirected_to edit_printsetting_path(@printsetting.project_id)
  end

end
