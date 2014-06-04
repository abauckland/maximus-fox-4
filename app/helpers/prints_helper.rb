module PrintsHelper

  def print_revision_select_list(project, revisions, revision)    
    if project.project_status == 'Draft'
      "<div class='project_label_select'>Project status is 'Draft'</div>".html_safe    
    else
      "<div class='project_label_select'>Revision:</div><div class='project_option_select'>#{print_revision_select_input(revisions, revision, project)}</div>".html_safe  
    end
  end

    
  def print_revision_select_input(revisions, revision, project)
    select_tag "revision", options_from_collection_for_select(revisions, :id, :rev, revision.id), {:class => 'publish_selectBox', :onchange => "window.location='/prints/#{project.id}?revision='+this.value;"}
  end
  
  
  def watermark_checkbox(print_status_show)    

    case print_status_show            
      when 'draft' ;  "A 'not for issue' watermark is placed on the documents when the specification is in Draft status.".html_safe
      when 'superseded' ; "The selected revision of the document has already been published. A watermark 'Superseded' will be added to each page".html_safe    
      when 'issue' ; "This document has already been published, no subsequent changes have been made to it. To create another copy click the 'Print Document' button".html_safe
      when 'not for issue' ; "Confirm this revision of the document will not be issued. A watermark 'Not for Issue' will be added to each page#{check_box_tag 'issue', true, checked = true}".html_safe    
    end

  end

  
  def print_help(print_status_show)
  
     case print_status_show            
      when 'draft' ;  render :partial => "print_help_draft"
      when 'superseded' ;  render :partial => "print_help_superseded"  
      when 'issue' ; 
      when 'not for issue' ; render :partial => "print_help"
    end
 
  end
    
end