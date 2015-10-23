class ClauseguidePolicy < Struct.new(:user, :clauseguide)

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

    def edit_all?
      index?
    end

    def update?
      index?
    end

    def destroy?
      index?
    end

    def clone?
      index?
    end

    def creae_clone?
      index?
    end

    def assign?
      index?
    end

    def assign_guides?
      index?
    end

    def duplicate?
      index?
    end

    def duplicate_guides?
      index?
    end

end
