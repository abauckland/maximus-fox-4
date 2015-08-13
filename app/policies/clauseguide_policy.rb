class ClauseguidePolicy < Struct.new(:user, :clauseguide)

    def index?
      user.admin?
    end

    def show?
      true
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
