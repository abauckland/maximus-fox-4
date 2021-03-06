module SpecrevisionsHelper
#revision select menu
  def revision_select(revisions, revision, project, subsections)

    if project.Draft?
      "<div class='revision_select_draft'>n/a</div>".html_safe
    else
      "<div class='revision_select_draft'>#{current_revision_render(project)}</div>".html_safe
#      if subsections.blank? && revision.rev == '-'
#        "<div class='revision_select_draft'>-</div>".html_safe
#      else
#        "<div class='revision_select'>#{revision_select_input(revisions, revision, project)}</div>".html_safe
#      end
    end
  end
 
#revision select menu
  def revision_select_input(revisions, revision, project)
    select_tag  "revision", options_from_collection_for_select(revisions, :id, :rev, revision.id), {:class => 'revision_selectBox', :onchange => "window.location='/specrevisions/#{project.id}?revision='+this.value;"}
  end


    def cawssubsection_change_data_helper(project, subsection, revision)
      subsection_change = Alteration.changed_caws_subsections_show(project, revision, subsection).first

      if subsection_change.clause_add_delete == 3
        if subsection_change.event == 'new'
          @added_subsection = subsection
        end
        if subsection_change.event == 'deleted'
          @deleted_subsection = subsection
        end
      else
        #@changed_subsection = subsection
      #check status of clause within changed subsection
        @added_clauses = Clause.changed_caws_clauses('new', project, revision, subsection)
        @deleted_clauses = Clause.changed_caws_clauses('deleted', project, revision, subsection)
        @changed_clauses = Clause.changed_caws_clause_content('changed', project, revision, subsection)
      end
    end

#  def get_class_and_href_ref(subsection_id, current_subsection_id)
  
 #   if subsection_id == current_subsection_id
#      "class='selected' href='##{subsection_id}rev_view'".html_safe
 #   else
#      "href='##{subsection_id}rev_view'".html_safe
#    end
#  end
  
##prelim
##subsections titles of subsections added or deleted   
# def changed_prelim_subsection_text(project, subsection)   
##    if project.CAWS?
#        "<table width='100%'><tr id='#{subsection.id.to_s}' class='clause_title'><td class='changed_subsection_code'>#{subsection.full_code_and_title.upcase}</td></tr></table>".html_safe 
#    else
#        "<table width='100%'><tr id='#{subsection.id.to_s}' class='clause_title'><td class='changed_subsection_code'>#{subsection.full_code_and_title.upcase}</td></tr></table>".html_safe     
#    end  
# end
   
#prelim  
#clause titles for added or deleted clauses   
#  def changed_clause_titles(clause, action, revision, project)
#    if clause
#        #check print status
#      if action != 'changed'
#          "<table width='100%' class='rev_table'><tr  id='#{clause.id.to_s}' class='clause_title_2'><td class='rev_clause_code'>#{clause_ref(clause)}</td><td class ='rev_clause_title'>#{clause.clausetitle.text.to_s}</td><td class='rev_line_menu_mob'>#{rev_mob_menu(clause)}</td><td class='rev_line_menu'>#{reinstate_original_clause(clause)}#{change_info_clause(clause, revision, project)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{reinstate_original_clause(clause)}#{change_info_clause(clause, revision, project)}</td></tr></table>".html_safe    
#      else
#
#        check_clause_print_status = Alteration.where(:project_id => @project, :clause_id => clause, :revision_id => @revision.id).collect{|item| item.print_change}.uniq            
#        if check_clause_print_status.include?(true)
#          "<table><tr class='clause_title'><td class='changed_clause_code'>#{clause_ref(clause)}</td><td class ='changed_clause_title'>#{clause.clausetitle.text.to_s}</td></tr></table>".html_safe    
#        else
#          "<table><tr class='clause_title_strike'><td class='changed_clause_code'>#{clause_ref(clause)}</td><td class ='changed_clause_title'>#{clause.clausetitle.text.to_s}</td></tr></table>".html_safe    
#        end
#      end
#    end
#  end

#non prelim
#statement of if non prelim subsection has been added or deleted
 def subsection_text(subsection, action)
   "<table class='rev_deleted_subsection_title' width ='100%'><tr><td class='rev_title'>#{subsection.full_code_and_title} #{action}.</td></tr></table>".html_safe 
 end

#non prelim
#set up anno for changed clauses
  def new_clauses_text(subsection)  
      if !@added_clauses.empty?
           clauses_text_show(subsection, 'added')
      end
  end
  
  def deleted_clauses_text(subsection)  
      if !@deleted_clauses.empty?
           clauses_text_show(subsection, 'deleted')
      end
  end
  
  def changed_clauses_text(subsection)  
      if !@changed_clauses.empty?
           clauses_text_show(subsection, 'changed')
      end
  end
  
  def clauses_text_show(subsection, action)
       "<table><tr><td class='rev_title_2'>Clauses #{action}:</td></tr></table>".html_safe
  end
 
#non prelim
#text of clause titles deleted or added
 def altered_clause_text(clause, revision, project)
 
    last_clause_change = Alteration.where('project_id = ? AND clause_id = ? AND clause_add_delete =?', project.id, clause.id, 2).last
    if revision.id == last_clause_change[:revision_id]
      "<table width='100%' class='rev_table'><tr id='#{clause.id.to_s}'class='clause_title_2'><td class='rev_clause_code'> #{clause_ref(project,clause)} </td><td class ='rev_clause_title'> #{clause.clausetitle.text.to_s}</td><td class='rev_line_menu'>#{change_info_clause(clause, revision, project)}</td><td class='rev_line_menu_mob'> #{rev_mob_menu(clause)} </td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info_clause(clause, revision, project)}</td></tr></table>".html_safe
    else
      "<table width='100%' class='rev_table'><tr id='#{clause.id.to_s}'class='clause_title_2'><td class='rev_clause_code'> #{clause_ref(project,clause)} </td><td class ='rev_clause_title'> #{clause.clausetitle.text.to_s} </td><td class='rev_line_menu'> #{change_info_clause(clause)} </td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info_clause(clause, revision, project)}</td><td class='rev_line_menu_mob'> #{rev_mob_menu(clause)} </td></tr></table>".html_safe
    end
 end

def changed_clause_titles(project, changed_clause, action)
      "<table width='100%' class='rev_table'><tr id='#{changed_clause.id.to_s}'class='clause_title_2'><td class='rev_clause_code'> #{clause_ref(project, changed_clause)} </td><td class ='rev_clause_title'> #{changed_clause.clausetitle.text.to_s} </td></tr></table>".html_safe  
end

#prelim and non prelim
#set up annotation for altered line      
 def clause_line_text_altered(project, revision, clause, action)
    @altered_lines = Alteration.where('project_id = ? AND clause_id = ? AND revision_id = ? AND event = ? AND linetype_id > ?', project.id, clause.id, revision.id, action, 2)
    
    unless @altered_lines.blank?
      check_print_status = Alteration.where('project_id = ? AND clause_id = ? AND revision_id = ? AND event = ? AND linetype_id > ? AND print_change = ?', project.id, clause.id, revision.id, action, 2, 1)
      if check_print_status.blank?
        "<table><tr id='#{clause.id.to_s}'><td class='rev_subtitle_strike'>Text #{action}:</td></tr></table>".html_safe
      else
        "<table><tr id='#{clause.id.to_s}'><td class='rev_subtitle'>Text #{action}:</td></tr></table>".html_safe
      end
    end
 end

 
 ####line formatting & links/actions 
  def original_line_text(line)
      
   #if line.print_change == true
      rev_line_class = 'rev_row' 
    #else
    #  rev_line_class = 'rev_row_strike'
    #end
    
    last_clause_change = Alteration.where(:specline_id => line.specline_id).last
    if line[:id] == last_clause_change[:id] 
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_line_class}'><td class='rev_row_padding'>#{line_content(line)}</td><td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{change_info(line)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info(line)}</td></tr></table>".html_safe    
    else
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_line_class}'><td class='rev_row_padding'>#{line_content(line)}</td><td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{change_info(line)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info(line)}</td></tr></table>".html_safe        
    end    
  end
   

  def changed_line_text(line, revision, project)
  
    if line.print_change == true
      rev_row_class = 'rev_row'
      change_title_class = 'change_title'
      change_line_class = 'change_line'
    else
      rev_row_class = 'rev_row_strike'
      change_title_class = 'change_title_strike'
      change_line_class = 'change_line_strike'
    end
       
    subsequent_changes = Alteration.where('id > ? AND specline_id = ?', line.id, line.specline_id) 
    if subsequent_changes.blank?
      current_line = Specline.find(line.specline_id)
    else
      current_line = Alteration.find(subsequent_changes.last.id)    
    end

    last_clause_change = Alteration.where(:specline_id => line.specline_id).last
    if line[:id] == last_clause_change[:id]   
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_row_class}'><td class='rev_row_padding'> <table width='100%'><tr><td class='#{change_title_class}'>From:</td></tr><tr><td class='#{change_line_class}'>#{line_content(line)}</td></tr><tr><td class='#{change_title_class}'>To:</td></tr><tr><td class='#{change_line_class}'>#{line_content(current_line)}</td></tr></table>  <td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr></table>".html_safe
    else  
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_row_class}'><td class='rev_row_padding'> <table width='100%'><tr><td class='#{change_title_class}'>From:</td></tr><tr><td class='#{change_line_class}'>#{line_content(line)}</td></tr><tr><td class='#{change_title_class}'>To:</td></tr><tr><td class='#{change_line_class}'>#{line_content(current_line)}</td></tr></table>  <td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr></table>".html_safe
    end    
  end
  
  def line_content(line) 
    
      case line.linetype_id
        when 3 ; "#{line.txt4.text}: #{line.txt5.text}".html_safe
        when 4 ; "#{line.txt4.text}".html_safe 
        when 5 ; "<table><tr><td>#{line.txt3.text}:</td><td width = '5'></td><td>#{line.txt6.text}</td></tr></table>".html_safe
        when 6 ; "<table><tr><td>#{line.txt3.text}:</td><td width = '5'></td><td>#{line.txt5.text}</td></tr></table>".html_safe
        when 7 ; "#{line.txt4.text}".html_safe
        when 8 ; "#{line.txt4.text}: #{line.txt5.text}".html_safe
        when 10 ; line_identity_content(line)
        when 11 ; "#{line.perform.performkey.text}: #{line.perform.performvalue.full_perform_value}".html_safe 
        when 12 ; "#{line.txt4.text}: #{line.txt5.text}".html_safe 
#       when 13 ; "#{line.txt4.text}: #{line.txt5.text}".html_safe           
    end  
  end

def line_identity_content(line)
  if specline.identity.identkey.text == "Manufacturer"
  "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_address}".html_safe
  else
  "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}".html_safe  
  end  
end


#revision line menu links/icons
  def rev_mob_menu(line)
    image_tag("menu.png", :mouseover =>"menu_rollover.png", :border=>0)    
  end

#  def reinstate_original_line(line)
#    if authorise_specline_view(['manage', 'edit', 'write'])
#      link_to image_tag("reinstate.png", :mouseover =>"reinstate_rollover.png", :border=>0), {:controller => "changes", :action => "reinstate", :id => line.id, :project_id => line.project_id}, :class => "get", :title => "reinstate"
#    end
#  end
  
#  def reinstate_original_clause(clause)
#    if authorise_specline_view(['manage', 'edit', 'write'])
#      link_to image_tag("reinstate.png", :mouseover =>"reinstate_rollover.png", :border=>0), {:controller => "changes", :action => "reinstate_clause", :id => clause.id, :project_id => @project.id, :revision_id => @selected_revision.id}, :class => "get", :title => "reinstate"
#    end
#  end
    
  def toggle_print_setting(line, revision, project)
   # if authorise_specline_view(['manage', 'edit', 'write'])
#      check_current_revision = Revision.where('project_id =?', project.id).last
#      if revision.id == check_current_revision.id
#        link_to image_tag("b_print.png", :mouseover =>"b_print_rollover.png", :border=>0), print_setting_alteration_path(line.id), :class => "put", :title => "print option"
#      end
  #  end
  end
  
  def change_info(line)
    link_to "", line_change_info_alteration_path(line.id), :class => "get",  :remote => true, :class => "line_info_icon", :title => "change info"
  end
  
  def change_info_clause(clause, revision, project)
    link_to "", clause_change_info_alteration_path(:id => project, :rev_id => revision, :clause_id => clause.id), :class => "get",  :remote => true, :class => "line_info_icon", :title => "change info"
  end

  def revision_help(revision, project)
      if project.project_status == 'Draft'
        render :partial => "revision_help_draft"
      else
        current_revision_check = Revision.select('id, rev, date').where('project_id = ?', project.id).last
        if current_revision_check.date != nil
          if revision.rev == '-'
            if current_revision_check.rev == '-'
              "<p>This document has not been published, changes are only recorded after the document has been published.</p>".html_safe
            else
              "<p>This is the first version of the document.</p>".html_safe  
            end
          else
            if current_revision_check.rev == '-'
              "<p>No changes have been made to the document since it was last published.</p>".html_safe
            else
              "<p>No changes have been made to the document since it was last published.</p>".html_safe
            end
          end
        else
          "<p>Changes to the document are only recorded after document has been published for the first time.</p>".html_safe
        end
      end   
  end

  def clause_ref(project, clause)
    clause.clauseref.subsection.method(set_subsection_name(@project)).call.full_code.to_s + '.' +clause.clauseref_code.to_s
  end

  def set_subsection_name(project)
    @subsection_name
  end

end