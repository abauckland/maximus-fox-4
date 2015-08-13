class KeynotePolicy < Struct.new(:user, :project)

  def project
    Project.joins(:projectusers).where('projectusers.id' => user.id).first
  end

  def show?
    true #problems with this and controlling view and menu item - clash between user and projectuser
#    if user.manage? || user.edit?
#      project.plan.basic?
#    end
  end

  def keynote_export?
    true #problems with this and controlling view and menu item - clash between user and projectuser
#    if user.manage? || user.edit?
#      project.plan.basic?
#    end
  end

end