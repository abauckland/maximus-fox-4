class SpecificationPolicy < Struct.new(:user, :project)


  def empty_project
    true
  end

  def show?
    true
  end

  def show_tab_content?
    true
  end


  def edit_clause?
    true
  end

  def edit_line?
    true
  end

end