module UsersHelper


  def created(user)
    user.created_at.strftime("%e %B %Y")
  end
  
  def licence_status(licences_used, no_licences)
    spare_licences = no_licences - licences_used
    if spare_licences > 0 
      "#{licences_used} licence(s) are currently active out of an available #{no_licences} licence(s)".html_safe
    else
      "<span style='color: #ff0000'>All the company's licences (#{no_licences}) are allocated</span>".html_safe
    end
  end
  
  
  def  check_active(user)
  
    if user.role == 'owner'
      "<div class='small_green_button'>active</div>".html_safe  
    else  
      if user.active == 0      
        "<div class='small_red_button'>#{activate(user)}</div>".html_safe
      else        
        "<div class='small_green_button'>#{deactivate(user)}</div>".html_safe
      end
    end    
  end
  
  
  def  last_seen(user)
    if !user.last_sign_in.blank?   
      user.last_sign_in.strftime("%e %B %Y")
    else
      "n/a"
    end
  end
  
  def  locked_at(user)
    if user.locked_at == 1
      "<div class='small_green_button'>#{remove_unlock(user)}</div>".html_safe   
    end
  end

  def deactivate(user)
    link_to 'active', update_status_user_path(user.id), :class => "get"
  end

  def activate(user)
    link_to 'inactive', update_status_user_path(user.id), :class => "get"
  end
  
  def remove_unlock(user)
    link_to 'locked', unlock_user_user_path(user.id), :class => "get"
  end
  

end
