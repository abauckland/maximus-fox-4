class UserPolicy < Struct.new(:user, :record)

  class Scope < Struct.new(:user, :scope)
    def resolve
        scope.where(:company_id => user.company_id)
    end
  end

    def administrator
      if user.admin?
        record.company_id == user.company_id
      end 
    end


    def index?
      user.admin?
    end

    def create?
      user.admin?
    end

    def edit?
      record.id == user.id
    end
    
    def update?
      edit?
    end
    
    def update_licence_status
      administrator     
    end
    
    def unlock_user
      administrator      
    end    
end