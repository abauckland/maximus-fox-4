class RegistrationPolicy < Struct.new(:user, :scope)

    def new?
      user.admin? || user.owner?
    end

    def new_employee?
      user.admin? || user.owner?
    end

    def create?
      user.admin? || user.owner?
    end

    def edit?
      true
    end
    
    def update?
      true
    end
end