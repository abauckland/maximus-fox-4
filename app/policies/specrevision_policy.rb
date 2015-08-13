class SpecrevisionPolicy < Struct.new(:user, :project)

  def show?
    true
  end

  def show_rev_tab_content?
    true
  end

end