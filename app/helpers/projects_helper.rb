module ProjectsHelper

  def index_help_text(project_user)

 #       if projects.length == 1
  #          if check_has_content
  #            existing_user_help_text 
  #          else
  #            new_user_help_text 
   #         end

    #      existing_user_help_text 
   #     end
 #   else   
      new_user_help_text(project_user) 

  end

  def new_user_help_text(project_user)   
    case project_user.role        
      when 'manage'   ; render :partial => "new_user_intro"
     # when 'edit'   ; render :partial => "new_user_intro"  
    #  when 'write'  ; 
    #  when 'read'   ; render :partial => "new_user_intro"
    end
  end  

  def existing_user_help_text   
     case current_user.role             
      when 'manage' ; render :partial => "current_user_intro"
      when 'edit'   ; render :partial => "current_user_intro" 
      when 'write'  ; 
      when 'read'   ; render :partial => "current_user_intro"
    end
  end 


  def authorise_project_view(project_id, permissible_roles)
    if permissible_roles == "all"
      return true
    else
      project_user = Projectuser.where(:user_id => current_user.id, :project_id => project_id, :role => permissible_roles).first    
      if project_user
        return true
      end
    end    
  end


end
