##control access to actions - but not records

class KeynotePlan
  attr_reader :project, :user

  def initialize(project, user)
    @project = project
    @user = user
  end

  def download?
    if user.manage? || user.edit?
      #get project plan through project user
      project.advanced? || project.premium?
    end
  end


  def scope
    check project is accessible to project user
    
  end


end






def download
  authorize_plan(keynote, @project)
  #create download

authorize :keynote, :download?

end



def plan(contoller, project)
  "#{contoller.class}Plan".constantize.new(project, pundit_project_user(project))
end

def authorize_plan(project)
  raise NotAuthorizedError unless plan(params[:controller], project).public_send(params[:action] + "?")
end

def pundit_project_user(project)
  #is @project variable accessible if method placed in controller?
  Projectuser.where(:user_id => current_user, :project_id => project.id).first
end


class Error < StandardError; end
class NotAuthorizedError < Error
end













