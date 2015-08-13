class SpecsubsectionPolicy < Struct.new(:user, :project)

  def manage?
    user.manage? || user.edit?
  end

  def add?
    user.manage? || user.edit?
  end

  def delete?
    user.manage? || user.edit?
  end

end