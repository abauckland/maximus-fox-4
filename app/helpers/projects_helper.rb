module ProjectsHelper

  def index_help_text(projects, check_has_content)

    if projects
        if projects.length == 1
            if check_has_content
              existing_user_help_text 
            else
              new_user_help_text 
            end
        else
          existing_user_help_text 
        end
    else   
      new_user_help_text 
    end
  end

  def new_user_help_text   
     case current_user.role           
      when 'manage' ; render :partial => "new_user_intro"
      when 'edit'   ; render :partial => "new_user_intro"  
      when 'write'  ; 
      when 'read'   ; render :partial => "new_user_intro"
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

end
