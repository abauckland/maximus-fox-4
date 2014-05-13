module WebsiteHelper

  def check_current_web(controller)
    if request.path_parameters[:controller] == controller
      return 'current_link'
    else
      return 'not_link'        
    end
  end


  def check_current(item)

    controller = request.path_parameters[:controller]
    action = request.path_parameters[:action]

    if controller == 'projects'
      if ['index', 'new', 'edit'].include?(action)
        check = 'project'
      else
        check = 'document'
      end
    end

    if controller == 'speclines'
        check = 'document'
    end
    
    if controller == 'clauses'
        check = 'document'
    end
    
    if controller == 'revisions'
        check = 'revision'
    end    

    if controller == 'prints'
        check = 'publish'
    end

    if check == item
      return 'current_link'
    else
      return 'not_link'          
    end       
  end

  
  def check_current_topic(topic)
    if request.parameters[:topic].blank? && topic == 'all'
        return 'current_topic'    
    end
    if request.parameters[:topic] == topic
        return 'current_topic'
    else
        return 'not_topic'    
    end
  end











  
end