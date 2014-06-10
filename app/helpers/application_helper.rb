module ApplicationHelper

  def check_current(item)

    controller = request.path_parameters[:controller]
    action = request.path_parameters[:action]

    if controller == 'projects'
        check = 'project'
    end

    if controller == 'specifications'
        check = 'document'
    end

    if controller == 'specsubsections'
        check = 'document'
    end
    
    if controller == 'clauses'
        check = 'document'
    end
    
    if controller == 'specrevisions'
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


  def error_check(company, field)
       if !company.errors[field].blank?
       "<t style='color: #ff0000'>#{company.errors[field][0]}</t>".html_safe
      end       
  end
  
  def label_error_check(model, label_field, label_text)
          if !model.errors[label_field].blank?    
        "<t style='color: #ff0000'>#{label_text}:</t>".html_safe
      else
        "#{label_text}:".html_safe
      end
  end
  
  def show_image(photo, height)
    if photo.photo_file_name
      image_tag (photo.photo.url), :height=> height
    else
      "No image has been uploaded".html_safe
    end
  end
  




end
