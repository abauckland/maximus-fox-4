class ProjectuserPolicy < Struct.new(:user, :projectuser)


  class Scope < Struct.new(:user, :scope)
    def resolve
      scope.where(:project_id => projectuser.project_id)
    end
  end

  def current_user
    User.find(user.id)
  end

  def show?
    current_user.admin?
  end

  def new?
    true
  end

  def create?
    user.manage?
  end

  def edit?
    user.manage?
  end

  def update?
    user.manage?
  end

  def destroy?
    user.manage?
  end

end
