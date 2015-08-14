module ProjectuserDetails
  extend ActiveSupport::Concern

    included do
      before_filter :set_project_user
      before_filter :pundit_user
    end


    def set_project_user
      @project_user = Projectuser.where(:user_id => current_user, :project_id => @project.id).first
    end

    def pundit_user
      @project_user
    end

end