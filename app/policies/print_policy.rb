class PrintPolicy < Struct.new(:user, :project)

  def project
    Project.joins(:projectusers).where('projectusers.id' => user.id).first
  end

  def show?
    true
  end

  def print_project?
    true
  end

  #option for downloading final document which advances revision and removes watermark
  def audit?
    false
  end


  def final?
    user.manage?
  end

end