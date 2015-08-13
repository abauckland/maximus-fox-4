class DataexportPolicy < Struct.new(:user, :help)

  def project
    Project.joins(:projectusers).where('projectusers.id' => user.id).first
  end

  def current_user
    User.find(user.id)
  end

  def show?
    current_user.admin?
#    if user.manage? || user.edit?
#      project.plan.basic?
#    end
  end

  def download?
    current_user.admin?
#    if user.manage? || user.edit?
#      project.plan.basic?
#    end
  end

end