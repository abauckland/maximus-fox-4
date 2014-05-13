class SpecificationPolicy < Struct.new(:user, :project)

  class Scope < Struct.new(:user, :scope)
    def resolve
        #get all project from the same company and other projects the user has been added to.
        scope.joins(:projectusers => :users).where('projectusers.user_id' => user.id)
    end
  end

    def owner
      user.admin? || user.user? 
    end


    def show?
        project.projectuser_id == user.id      
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