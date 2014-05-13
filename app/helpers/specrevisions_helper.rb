module SpecvisionsHelper
#revision select menu
  def revision_select(revisions, revision, project, subsections)

    if project.project_status == 'Draft'
      "<div class='revision_select_draft'>n/a</div>".html_safe
    else
      #if revision_subsections.blank?
      #  "<div class='revision_select_draft'>n/a (no changes have been made)</div>".html_safe
      #else
        "<div class='revision_select'>#{revision_select_input(revisions, revision, project)}</div>".html_safe
      #end
    end
  end

#revision select menu
  def revision_select_input(revisions, revision, project)
    select_tag  "revision", options_from_collection_for_select(revisions, :id, :rev, revision.id), {:class => 'revision_selectBox', :onchange => "window.location='/revisions/#{project.id}?revision='+this.value;"}
  end


#  def get_class_and_href_ref(subsection_id, current_subsection_id)
  
 #   if subsection_id == current_subsection_id
#      "class='selected' href='##{subsection_id}rev_view'".html_safe
 #   else
#      "href='##{subsection_id}rev_view'".html_safe
#    end
#  end
  
#prelim
#subsections titles of subsections added or deleted   
 def changed_prelim_subsection_text(changed_subsection)   
    if @project.ref_system.caws?
        "<table width='100%'><tr id='#{changed_subsection.cawssubsection.id.to_s}' class='clause_title'><td class='changed_subsection_code'>#{changed_subsection.cawssubsection.full_code_and_title.upcase}</td></tr></table>".html_safe 
    else
        "<table width='100%'><tr id='#{changed_subsection.unisubsection.id.to_s}' class='clause_title'><td class='changed_subsection_code'>#{changed_subsection.unisubsection.full_code_and_title.upcase}</td></tr></table>".html_safe     
    end  
 end
 
#prelim
#annotation for altered clauses
  def new_prelim_clauses_text(subsection)  
      if !@added_prelim_clauses[subsection.id].blank?
            prelim_clauses_show(subsection, 'added')
      end  
  end
  
  def deleted_prelim_clauses_text(subsection)  
      if !@hdeleted_prelim_clauses[subsection.id].blank?
            prelim_clauses_show(subsection, 'deleted')
      end  
  end
  
  def changed_prelim_clauses_text(subsection)  
      if !@changed_prelim_clauses[subsection.id].blank?
            prelim_clauses_show(subsection, 'changed')
      end  
  end
  
  def prelim_clauses_show(subsection, action)
        "<table><tr><td class='rev_subsection_action'>Clauses #{action}:</td></tr></table>".html_safe
  end
  
#prelim  
#clause titles for added or deleted clauses   
  def changed_clause_titles(clause, action)
    if clause
        #check print status
      if action != 'changed'
          "<table width='100%' class='rev_table'><tr  id='#{clause.id.to_s}' class='clause_title_2'><td class='rev_clause_code'>#{clause_ref_text(clause)}</td><td class ='rev_clause_title'>#{clause.clausetitle.text.to_s}</td><td class='rev_line_menu_mob'>#{rev_mob_menu(clause)}</td><td class='rev_line_menu'>#{reinstate_original_clause(clause)}#{change_info_clause(clause)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{reinstate_original_clause(clause)}#{change_info_clause(clause)}</td></tr></table>".html_safe    
      else

        check_clause_print_status = Change.where(:project_id => @project, :clause_id => clause, :revision_id => @revision.id).collect{|item| item.print_change}.uniq            
        if check_clause_print_status.include?(true)
          "<table><tr class='clause_title'><td class='changed_clause_code'>#{clause_ref_text(clause)}</td><td class ='changed_clause_title'>#{clause.clausetitle.text.to_s}</td></tr></table>".html_safe    
        else
          "<table><tr class='clause_title_strike'><td class='changed_clause_code'>#{clause_ref_text(clause)}</td><td class ='changed_clause_title'>#{clause.clausetitle.text.to_s}</td></tr></table>".html_safe    
        end
      end
    end
  end

#non prelim
#statement of if non prelim subsection has been added or deleted    
 def new_subsection_text(revision_subsection)   
    if @added_subsections[revision_subsection.id] == 'added'
        subsection_text_show(revision_subsection, 'added') 
    end
 end
 
 def deleted_subsection_text(revision_subsection)   
    if @deleted_subsections[revision_subsection.id] == 'deleted'
        subsection_text_show(revision_subsection, 'deleted') 
    end
 end
  
 def subsection_text_show(revision_subsection, action)
   "<table class='rev_deleted_subsection_title' width ='100%'><tr><td class='rev_title'>#{revision_subsection.subsection_full_code_and_title} #{action}.</td></tr></table>".html_safe 
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
 
    last_clause_change = Change.where('project_id = ? AND clause_id = ? AND clause_add_delete =?', project.id, clause.id, 2).last
    if revision.id == last_clause_change[:revision_id]
      "<table width='100%' class='rev_table'><tr id='#{clause.id.to_s}'class='clause_title_2'><td class='rev_clause_code'> #{clause_ref_text(clause)} </td><td class='rev_line_menu_mob'> #{rev_mob_menu(clause)} </td><td class ='rev_clause_title'> #{clause.clausetitle.text.to_s}</td><td class='rev_line_menu'>#{reinstate_original_clause(clause)}#{change_info_clause(clause)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{reinstate_original_clause(clause)}#{change_info_clause(clause)}</td></tr></table>".html_safe   
    else
      "<table width='100%' class='rev_table'><tr id='#{clause.id.to_s}'class='clause_title_2'><td class='rev_clause_code'> #{clause_ref_text(clause)} </td><td class='rev_line_menu_mob'> #{rev_mob_menu(clause)} </td><td class ='rev_clause_title'> #{clause.clausetitle.text.to_s} </td><td class='rev_line_menu'> #{change_info_clause(clause)} </td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info_clause(clause)}</td></tr></table>".html_safe    
    end
 end

def clause_ref_text(clause)                                                        
  if @project.ref_system.caws?
    clause.clauseref.subsection.cawssubsection.cawssection.ref.to_s + clause.clauseref.subsection.cawssubsection.ref.to_s + clause.clauseref.clausetype_id.to_s + clause.clauseref.clause.to_s + clause.clauseref.subclause.to_s  
  else
    clause.clauseref.subsection.unisubsection.unisection.ref.to_s + clause.clauseref.subsection.unisubsection.ref.to_s + clause.clauseref.clausetype_id.to_s + clause.clauseref.clause.to_s + clause.clauseref.subclause.to_s   
  end  
end

#prelim and non prelim
#set up annotation for altered line      
 def clause_line_text_altered(clause, action)

    @altered_lines = Change.where('project_id = ? AND clause_id = ? AND revision_id = ? AND event = ? AND linetype_id > ?', @project.id, clause.id, @revision.id, action, 2).order('specline_id')
    if !@altered_lines.blank?        
      check_added_print_status = @altered_lines.collect{|item| item.print_change}.uniq
      if check_added_print_status.include?(true) 
        "<table><tr id='#{clause.id.to_s}'><td class='rev_subtitle'>Text #{action}:</td></tr></table>".html_safe
      else
        "<table><tr id='#{clause.id.to_s}'><td class='rev_subtitle_strike'>Text #{action}:</td></tr></table>".html_safe
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
    
    last_clause_change = Change.where(:specline_id => line.specline_id).last
    if line[:id] == last_clause_change[:id] 
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_line_class}'><td class='rev_row_padding'>#{line_content(line)}</td><td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{reinstate_original_line(line)}#{change_info(line)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{reinstate_original_line(line)}#{change_info(line)}</td></tr></table>".html_safe    
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
       
    subsequent_changes = Change.where('id > ? AND specline_id = ?', line.id, line.specline_id)
    array_subsequent_changes = subsequent_changes.collect{|item| item.id}
    subsequent_change = array_subsequent_changes[0]
 
    if subsequent_changes.blank?
      current_line = Specline.find(line.specline_id)
    else
      current_line = Change.find(subsequent_change)    
    end

    last_clause_change = Change.where(:specline_id => line.specline_id).last
    if changed_line[:id] == last_clause_change[:id]   
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_row_class}'><td class='rev_row_padding'> <table width='100%'><tr><td class='#{change_title_class}'>From:</td></tr><tr><td class='#{change_line_class}'>#{line_content(line)}</td></tr><tr><td class='#{change_title_class}'>To:</td></tr><tr><td class='#{change_line_class}'>#{line_content(current_line)}</td></tr></table>  <td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{reinstate_original_line(line)}#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{reinstate_original_line(line)}#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr></table>".html_safe
    else  
      "<table width='100%' class='rev_table'><tr id='#{line.id.to_s}' class='#{rev_row_class}'><td class='rev_row_padding'> <table width='100%'><tr><td class='#{change_title_class}'>From:</td></tr><tr><td class='#{change_line_class}'>#{line_content(line)}</td></tr><tr><td class='#{change_title_class}'>To:</td></tr><tr><td class='#{change_line_class}'>#{line_content(current_line)}</td></tr></table>  <td class='rev_line_menu_mob'>#{rev_mob_menu(line)}</td><td class='rev_line_menu'>#{change_info(line)}#{toggle_print_setting(line, revision, project)}</td></tr><tr class='rev_mob_menu_popup'><td class='mob_rev_menu' colspan=3 >#{change_info(line)}#{toggle_print_setting(line, srevision, project)}</td></tr></table>".html_safe
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

  def reinstate_original_line(line)
    if authorise_specline_view(['manage', 'edit', 'write'])
      link_to image_tag("reinstate.png", :mouseover =>"reinstate_rollover.png", :border=>0), {:controller => "changes", :action => "reinstate", :id => line.id, :project_id => line.project_id}, :class => "get", :title => "reinstate"
    end
  end
  
  def reinstate_original_clause(clause)
    if authorise_specline_view(['manage', 'edit', 'write'])
      link_to image_tag("reinstate.png", :mouseover =>"reinstate_rollover.png", :border=>0), {:controller => "changes", :action => "reinstate_clause", :id => clause.id, :project_id => @current_project.id, :revision_id => @selected_revision.id}, :class => "get", :title => "reinstate"
    end
  end
    
  def toggle_print_setting(line, revision, project)
    if authorise_specline_view(['manage', 'edit', 'write'])
      check_current_revision = Revision.where('project_id =?', project.id).last
      if selected_revision.id == check_current_revision.id
        link_to image_tag("b_print.png", :mouseover =>"b_print_rollover.png", :border=>0), {:action => "print_setting", :id => line.id}, :class => "put", :title => "print option"
      end
    end
  end
  
  def change_info(line)
    link_to image_tag("info.png", :mouseover =>"info_rollover.png", :border=>0), {:controller => "revisions", :action => "line_change_info", :id => line.id}, :class => "get", :title => "change info"
  end
  
  def change_info_clause(clause)
    link_to image_tag("info.png", :mouseover =>"info_rollover.png", :border=>0), {:controller => "revisions", :action => "clause_change_info", :id => @current_project, :rev_id => @selected_revision, :clause_id => clause.id}, :class => "get", :title => "change info"
  end

  def revision_help(revision_subsections, revision, project)
    if revision_subsections.blank?
      if project.project_status == 'Draft'
        render :partial => "revision_help_draft"
      else
        current_revision_check = Revision.select('id, rev, date').where('project_id = ?', project.id).last
        if current_revision_check.date != nil
          if revision.rev == '-'
            if current_revision_check.rev == '-'
              "<p>No changes have been made to this document.</p>".html_safe
            else
              "<p>This is the first version of the document.</p>".html_safe  
            end
          else
            if current_revision_check.rev == '-'
              "<p>No changes have been made to the document since it was last published.</p>".html_safe
            else
              "<p>This is the first version of the document.</p>".html_safe
            end
          end
        else
          "<p>Changes to the document are only recorded after document has been published for the first time.</p>".html_safe
        end
      end   
    end
  end
  
end