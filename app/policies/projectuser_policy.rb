
class ProjectuserPolicy < Struct.new(:user, :projectuser)

#list of projects accessible to user
#list of users for project


    class Scope < Struct.new(:user, :scope)
      def resolve
          #projectuser records where current user is a user
          scope.where(:user_id => user.id)
      end
    end


#    def owned
#      if user.admin? || user.owner?
#        projectuser.manager_id == user.id
#      end
#    end


    def index?
#only if a project user of the project
      true
#record.company_id == user.company_id
    end

    def new?
#only if a project user and manager of the project
      true
#      user.projetuser.manage?
    end

    def create?
#only if a project user and manager of the project
      true
#      user.projetuser.manage?
    end

    def edit?
      #only if manager of the project user
      projectuser.manager_id == user.id
    end

    def update?
      #only if manager of the project user
      projectuser.manager_id == user.id
    end

end
