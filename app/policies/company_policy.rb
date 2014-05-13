
class CompanyPolicy < Struct.new(:user, :company)

    def owned
      if user.admin?
        company.id == user.company_id
      end
    end
        
    def new?
      true
    end
    
    def create?
      true
    end    

    def edit?
      owned
    end
    
    def update?
      edit?
    end
              
end