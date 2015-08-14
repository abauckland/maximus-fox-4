class ProjectPolicy < Struct.new(:user, :project)


#  class Scope < Struct.new(:user, :scope)
#    def resolve
#        scope.joins(:projectusers).where('projectusers.user_id' => user.id).order("code")
#    end
#  end


  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    true #problems with this and controlling view and menu item - clash between user and projectuser
  end

  def update?
    true #problems with this and controlling view and menu item - clash between user and projectuser
  end

end