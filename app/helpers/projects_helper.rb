module ProjectsHelper


  def new_user_intro          
      render :partial => "new_user_intro"
  end  

  def existing_user_intro(project_user)    
     case project_user.role             
      when 'manage' ; render :partial => "user_intro"
      when 'edit'   ; render :partial => "user_intro" 
      when 'write'  ; render :partial => "user_intro" 
      when 'read'   ; render :partial => "user_intro"
    end
  end 

end
