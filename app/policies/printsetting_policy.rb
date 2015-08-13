class PrintsettingPolicy < Struct.new(:user, :printsetting)

  def project
    Project.joins(:projectusers).where('projectusers.id' => user.id).first
  end

  def edit?
    true #problems with this and controlling view and menu item - clash between user and projectuser
  end

  def update?
    true #problems with this and controlling view and menu item - clash between user and projectuser
  end

end