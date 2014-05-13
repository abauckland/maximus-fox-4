class ProjectPolicy < Struct.new(:user, :project)

  class Scope < Struct.new(:user, :scope)
    def resolve
        #get all projects the user has been added to.
        scope.joins(:projectusers => :users).where('projectusers.user_id' => user.id)#.where('users.company_id' => user.company_id)
    end
  end

    def owner
      user.admin? || user.user? 
    end


    def index?
      owner
    end

    def new?
      owner
    end
    
    def create?
      owner
    end 

    def empty_project?
      owner
    end

    def edit?      
      projectuser = Projectuser.where(:project_id => project.id, :user_id => user.id).first      
      if projectuser.owner? || projectuser.manager?
        return true
      end
    end
    
    def update?
      edit?
    end   
end