class SpecclausePolicy < Struct.new(:user, :project)

  def manage?
    #obly nmanage if have edit rights and access to subsection
    user.manage? || user.edit?
  end

  def add_clauses?
    user.manage? || user.edit?
  end

  def delete_clauses?
    user.manage? || user.edit?
  end

end