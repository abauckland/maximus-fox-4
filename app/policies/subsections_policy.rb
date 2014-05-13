class SubsectionPolicy < Struct.new(:user, :subsection)

  class Scope < Struct.new(:user, :scope)
    def resolve
        #get all project from the same company and other projects the user has been added to.
        
        #if user_company_id does not equal project owner company_id
        scope.joins(:subsectionusers => :users).where('subsectionusers.user_id' => user.id)
    end
  end
   
end