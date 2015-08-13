class ClausePolicy < Struct.new(:user, :project)

  def new?
    user.manage? || user.edit?
  end

  def create?
    user.manage? || user.edit?
  end

end