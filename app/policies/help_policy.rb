
class HelpPolicy < Struct.new(:user, :help)
        
    def index?
      user.admin?
    end
    
    def show?
      index?
    end
    
    def new?
      index?
    end
    
    def create?
      index?
    end    

    def edit?
      index?
    end
    
    def update?
      index?
    end
    
    def destroy?
      index?
    end 
       
end
