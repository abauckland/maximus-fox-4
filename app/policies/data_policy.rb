
class DataPolicy < Struct.new(:user, :help)


    def show?
      true
    end
    
    def download?
      index?
    end

end
