module ApplicationHelper

  def check_current(menu_controller)

    controller = request.path_parameters[:controller]
    action = request.path_parameters[:action]

    if menu_controller == 'projects'
      if controller == menu_controller
          return "nav_underline"
      else
          return "nav_no_underline"
      end
    end

    if menu_controller == 'specifications'
      if controller == 'specifications' || controller == 'specsubsections' || controller == 'specclauses'
          return "nav_underline"
      else
          return "nav_no_underline"
      end
    end

    if menu_controller == 'revisions'
      if controller == 'specrevisions'
          return "nav_underline"
      else
          return "nav_no_underline"
      end
    end

    if menu_controller == 'prints'
      if controller == 'prints' || controller == 'printsettings' || controller == 'keynotes'
          return "nav_underline"
      else
          return "nav_no_underline"
      end
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


  def current_revision_render(project)

    revisions = Revision.where(:project_id => project.id).order('created_at')         
    last_rev_check = Alteration.where(:project_id => project.id, :revision_id => revisions.last.id).first
    if last_rev_check.blank?
      #count of revision records indicates the revision rev no
      #first revision record, when document is in draft - rev == NULL
      #second revision records, when document has been issued for the first time - rev == '-'
      #third revision record, when document has been issued and then revised - rev =='a'
      
      #if no changes recorded for current revision record then last record still applies
      #reduce record count by 1 to indicate this
      rev_number = revisions.count
      current_rev_number = rev_number-1
    end  
    
    if current_rev_number == 0 #revision rev == NULL
      return "n/a".html_safe
    else  
      if current_rev_number == 1 #revision rev == '-'
       return "-".html_safe
      else    
        return "#{revisions.last.rev.capitalize}".html_safe
      end
    end
  end  

    def row_activate_link(model, display)
      link_to '', polymorphic_path([:activate, model]), :method => :get, :remote => true, class: ('line_activate_icon_' << display) , title: "assign licence to user"
    end

    def row_deactivate_link(model, display)
      link_to '', polymorphic_path([:deactivate, model]), :method => :get, :remote => true, class: ('line_deactivate_icon_' << display) , title: "remove user licence"
    end


end
