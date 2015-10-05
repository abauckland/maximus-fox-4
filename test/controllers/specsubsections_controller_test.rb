require 'test_helper'

class SpecsubsectionsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
    @project_rev = projects(:CAWS_rev)
    @project_template = projects(:CAWS_template)
  end

#authorization
  test "not authenticated should get redirect" do
    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response :redirect
  end

  test "if user role is read should get redirect" do
    sign_in users(:employee_2)

    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response 403
  end

  test "should not add section but redirect if user role is read" do
    sign_in users(:employee_2)
    post :add, id: @project.id, template_id: 13, template_sections: [5]
    assert_response 403
  end

  test "should not delete section but redirect if user role is read" do
    sign_in users(:employee_2)
    post :delete, id: @project.id, project_sections: [2]
    assert_response 403
  end


#manage
  test "should show project and template sections" do
    sign_in users(:owner)

    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response :success

    assert_not_nil assigns(:template)
    assert_not_nil assigns(:templates)
    assert_not_nil assigns(:project_subsections)
    assert_not_nil assigns(:template_subsections)
  end


#add_subsections
  test "should add subsections" do
    sign_in users(:owner)

    assert_difference('Specline.count', +4) do
      post :add, id: @project.id, template_id: 13, template_sections: [5]
    end

#    #redirect to index if saved
    assert_redirected_to manage_specsubsection_path(id: @project.id, template_id: 13)
  end

  test "should add subsections but not alterations" do
    sign_in users(:owner)
    assert_no_difference('Alteration.count') do
      post :add, id: @project.id, template_id: 13, template_sections: [5]
    end
  end

  test "should add subsections and alterations" do
    sign_in users(:owner)
    assert_difference('Alteration.count', +4) do
      post :add, id: @project_rev.id, template_id: 13, template_sections: [5]
    end
  end



#delete_subsections
  test "should remove subsections" do
    sign_in users(:owner)

    assert_difference('Specline.count', -4) do
      post :delete, id: @project.id, project_sections: [2,3]
    end

#    #redirect to index if saved
    assert_redirected_to manage_specsubsection_path(id: @project.id)
  end

#delete subsections with revision tracking on
  test 'should remove subsections but not alterations' do
    sign_in users(:owner)
    assert_no_difference('Alteration.count') do
      post :delete, id: @project.id, project_sections: [2]
    end
  end

#delete subsections with revision tracking on
  test 'should remove subsections and add alterations' do
    sign_in users(:owner)
    assert_difference('Alteration.count', +2) do
      post :delete, id: @project_rev.id, project_sections: [2]
    end
  end

end