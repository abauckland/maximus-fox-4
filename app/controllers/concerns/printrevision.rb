module Printrevision

def revisions(project, subsection, revision)

#get all revisions for subsection
#return list of changes
  if project.ref_system.caws?

      subsection = Alteration.changed_caws_subsections(project, revision, subsection)
      
      if subsection
        if subsection.event == 'new'
          susbection(subsection, "added")
        elsif subsection.event == 'deleted'
          susbection(subsection, "deleted")
        else    
        
          added_clauses = Clause.changed_caws_clauses('new', project, revision, subsection)
          if added_clauses
            clauses_title("added")

            added_clauses.each do |clause|
              rev_clause(clause, "added")          
            end
          end  
        
          deleted_clauses = Clause.changed_caws_clauses('deleted', project, revision, subsection)
          if deleted_clauses
            clauses_title("deleted")

            deleted_clauses.each do |clause|
              rev_clause(clause, "deleted")           
            end
          end 
                
          changed_clauses = Clause.changed_caws_clauses('changed', project, revision, subsection)
          if changed_clauses
            clauses_title("changed")

            changed_clauses.each do |clause|
             
             rev_clause(clause, "changed") 
             
             #get deleted lines
             deleted_lines = Alteration.where(:event => 'deleted', :project_id => project.id, :clause_id => clause.id, :revision_id => revision.id)
             if deleted_lines
               lines_title("deleted")
               deleted_lines.each do |line|
                 rev_line(clause, line, "deleted")
               end
             end
 
             #get added lines
             added_lines = Alteration.where(:event => 'new', :project_id => project.id, :clause_id => clause.id, :revision_id => revision.id)
             if added_lines
               lines_title("added")
               added_lines.each do |line|
                 rev_line(clause, line, "added")
               end
             end
                          
             #get changed lins 
             changed_lines = Alteration.where(:event => 'changed', :project_id => project.id, :clause_id => clause.id, :revision_id => revision.id)
             if changed_lines
               lines_title("changed")
               changed_lines.each do |line|
                 rev_changed_line(clause, line, "changed")
               end
             end
             
            end
          end
        end      
      end
  else
#uniclass code here    
  end  
end


def subsection(section, action)  
  rev_subsection_style = {:size => 12, :style => :bold_italic}
  
  pdf.spec_box "Subsection #{action}", rev_subsection_style.merge(:at => [0.mm, pdf.y])
  pdf.move_down(pdf.box_height + 2.mm)
end



def clauses_title(action)
  rev_clause_style = {:size => 11, :style => :bold}
  
  y_position = pdf.y 
  
  pdf.draft_text_box "Clauses deleted:", rev_clause_style.merge(:at => [10.mm, pdf.y])
  pdf.move_down(pdf.daft_box_height + 2.mm)
  
  if pdf.y <= 24.mm
    pdf.start_new_page
    pdf.y = 268.mm
  else
    pdf.y = y_position   
  end
  
  pdf.spec_box "Clauses #{action}:", rev_clause_style.merge(:at => [10.mm, pdf.y])
  pdf.move_down(pdf.box_height + 2.mm)      
end





def rev_clause(clause, action)
    rev_clause_code_title_style = {:size => 11, :style => :bold, :overflow => :expand}    
    
    y_position = pdf.y
    
    pdf.draft_text_box "#{clause.clausetitle.text}", rev_clause_code_title_style.merge( :at => [35.mm, pdf.y])
    pdf.move_down(pdf.daft_box_height + 2.mm)
    
    if pdf.y <= 16.mm
      
      pdf.spec_box 'List of clauses continued on next page...', :size => 9, :style => :italic, :at =>[20.mm, 14.mm]      
      pdf.start_new_page
      pdf.y = 268.mm      
      pdf.spec_box "Clauses #{action} continued:", :size => 11, :style => :bold_italic, :at => [10.mm, pdf.y]
      
    else
      pdf.y = y_position   
    end    

    pdf.spec_box "#{clause.clause_code}", rev_clause_code_title_style.merge(:at => [15.mm, pdf.y])
    pdf.spec_box "#{clause.clausetitle.text}", rev_clause_code_title_style.merge( :at => [35.mm, pdf.y])
    pdf.move_down(pdf.box_height + 2.mm)    
end



def lines_title(action)
  rev_line_action_style = {:size => 9, :style => :bold_italic}
  
  y_position = pdf.y 
  
  pdf.draft_text_box "Text #{action}:", rev_line_action_style.merge(:at => [35.mm, pdf.y])
  pdf.move_down(pdf.draft_box_height + 1.mm)
  
  if pdf.y <= 24.mm
    pdf.start_new_page
    pdf.y = 268.mm
  else
    pdf.y = y_position   
  end
  
  pdf.spec_box "Text #{action}:", rev_line_action_style.merge(:at => [35.mm, pdf.y])
  pdf.move_down(pdf.box_height + 1.mm)      
end


def rev_line(clause, line, action)    
    y_position = pdf.y
    
    rev_line_draft(line, pdf)
    pdf.move_down(pdf.box_height + 2.mm) 
    
    if pdf.y <= 16.mm
      
      pdf.spec_box 'List of#{action} lines continued on next page...', :size => 9, :style => :italic, :at =>[20.mm, 14.mm]      
      pdf.start_new_page
      pdf.y = 268.mm      
      pdf.spec_box "Lines #{action} in #{clause.clause_code} continued:", :size => 11, :style => :bold_italic, :at => [10.mm, pdf.y]
      
    else
      pdf.y = y_position   
    end    

    rev_line_print(line, pdf)
    pdf.move_down(pdf.box_height + 2.mm)    
end



def rev_changed_line(clause, line, action)    
    
    line_sub_action_style = {:size => 8, :style => :italic}
    line_rev_limited_style = {:size => 10, :style => :italic, :overflow => :expand}

    current_line = Specline.find(changed_line.specline_id) 
    
    y_position = pdf.y
    
    if line.print_change?
        
      pdf.draft_text_box "From:", line_sub_action_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.box_height)
              
      rev_line_draft(previous_line, pdf)
      pdf.move_down(pdf.draft_box_height)
                            
      pdf.draft_text_box "To:", line_sub_action_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.box_height)
              
      rev_line_draft(current_line, pdf)
      pdf.move_down(pdf.draft_box_height + 2.mm)
    else
      pdf.draft_text_box "Spelling/grammatical correction to line #{current_line.clause_line}", line_rev_limited_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.draft_box_height + 2.mm)              
    end       


   
    if pdf.y <= 16.mm
      
      pdf.spec_box 'List of #{action} lines continued on next page...', :size => 9, :style => :italic, :at =>[20.mm, 14.mm]      
      pdf.start_new_page
      pdf.y = 268.mm      
      pdf.spec_box "Lines #{action} in #{clause.clause_code} continued:", :size => 11, :style => :bold_italic, :at => [10.mm, pdf.y]
      
    else
      pdf.y = y_position   
    end
        

    if line.print_change?
              
      pdf.spec_box "From:", line_sub_action_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.box_height)
                
      rev_line_print(previous_line, pdf)
      pdf.move_down(pdf.box_height)

      pdf.spec_box "To:", line_sub_action_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.box_height)
                                 
      rev_line_print(current_line, pdf)
      pdf.move_down(pdf.box_height + 2.mm) 

    else          
      pdf.spec_box "Spelling/grammatical correction to line #{current_line.clause_line}", line_rev_limited_style.merge(:at =>[35.mm, pdf.y])
      pdf.move_down(pdf.box_height + 2.mm) 
    end                
end




def rev_line_draft(line, pdf)
#font styles for lines
  font_style_rev_line = {:size => 10}
#formating for lines  
  rev_line_format = font_style_rev_line.merge(:width => 134.mm, :overflow => :expand)

    case line.linetype_id       
      when 3 ; pdf.draft_text_box "#{line.txt4.text}", rev_line_format.merge(:at =>[40.mm, pdf.y])       
      when 4 ; pdf.draft_text_box "#{ine.txt4.text}: #{line.txt5.text}", rev_line_format.merge(:at =>[40.mm, pdf.y])  
      when 7 ; pdf.draft_text_box "#{line.txt4.text}", rev_line_format.merge(:at =>[40.mm, pdf.y]) 
      when 8 ; pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", rev_line_format.merge(:at =>[40.mm, pdf.y])
      when 10 ; rev_draft_linetype_10_helper(line, rev_line_format, pdf) 
      when 11 ; pdf.draft_text_box "#{line.perform.performkey.text}: #{line.identity.perform.performvalue.full_perform_value}", rev_line_format.merge(:at =>[40.mm, pdf.y])  
      when 12 ; pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", rev_line_format.merge(:at =>[40.mm, pdf.y])           
    end    
end


def rev_draft_linetype_10_helper(line, rev_line_format, pdf) 
  if line.identity.identkey.text == "Manufacturer"
     pdf.draft_text_box "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_name}", rev_line_format.merge(:at =>[40.mm, pdf.y]) 
  else
     pdf.draft_text_box "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}", rev_line_format.merge(:at =>[40.mm, pdf.y]) 
  end
end



def rev_line_print(line, row_y_b, pdf)
  font_style_specline = {:size => 10}
  
  indent_format = font_style_specline.merge(:width => 3.mm) 
  specline_format = font_style_specline.merge(:width => 134.mm, :overflow => :expand)
  
  case line.linetype_id
    when 1, 2 then print_linetype_1_helper(line, row_y_b, pdf) 
    when 3 then rev_print_linetype_3_helper(line, indent_format, specline_format, pdf)        
    when 4 then rev_print_linetype_4_helper(line, indent_format, specline_format, pdf) 
    when 7 then rev_print_linetype_7_helper(line, indent_format, specline_format, pdf) 
    when 8 then rev_print_linetype_8_helper(line, indent_format, specline_format, pdf)
    when 10 then rev_print_linetype_8_helper(line, indent_format, specline_format, pdf)
    when 11 then rev_print_linetype_8_helper(line, indent_format, specline_format, pdf)
    when 12 then rev_print_linetype_8_helper(line, indent_format, specline_format, pdf)                   
  end    
end


def rev_print_linetype_3_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[40.mm, pdf.y])
end

def rev_print_linetype_4_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
    pdf.spec_box "#{line.txt4.text}", specline_format.merge(:at =>[40.mm, pdf.y])
end

def rev_print_linetype_7_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  pdf.spec_box "#{line.txt4.text}", specline_format.merge(:at =>[40.mm, pdf.y])
end

def rev_print_linetype_8_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[40.mm, pdf.y])
end

def rev_print_linetype_10_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  if line.identity.identkey.text == "Manufacturer"
    pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_name}", specline_format.merge(:at =>[40.mm, pdf.y])
  else
    pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}", specline_format.merge(:at =>[40.mm, pdf.y])
  end
end

def rev_print_linetype_11_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  pdf.spec_box "#{line.perform.performkey.text}: #{line.identity.perform.performvalue.full_perform_value}", specline_format.merge(:at =>[40.mm, pdf.y])
end

def rev_print_linetype_12_helper(line, indent_format, specline_format, pdf)
  pdf.spec_box '-', indent_format.merge(:at => [37.mm, pdf.y])
  pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[40.mm, pdf.y])
end


end

