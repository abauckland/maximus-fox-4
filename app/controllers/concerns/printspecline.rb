module Printspecline
  
def specification(project, subsection, revision, issue, pdf)

    user_array = User.joins(:projectusers).where('projectusers.project_id' => project.id).order(:email).ids
    #get array of linetypes that have a prefix
    prefixed_linetypes_array = Linetype.where('txt1 = ?', 1).ids

    clausetypes = Clausetype.includes(:clauserefs => [:clauses => :speclines]).where('speclines.project_id' => project, 'clauserefs.subsection_id' => subsection.id).order('clausetypes.id')
    clausetypes.each do |clausetype|


      #get all speclines for each clausetype    
      clausetype_speclines = Specline.includes(:clause => [:clauseref]).where(:project_id => project, 'clauserefs.subsection_id' => subsection.id, 'clauserefs.clausetype_id' => clausetype.id).order('clauserefs.clause_no, clauserefs.subclause, clause_line');

      clausetype_speclines.each_with_index do |line, i|

        #save y position to refernce after dry run
        y_position = pdf.y

        #check fit of line, and related subsequent lines
        print_line_space_check(line, i, clausetype_speclines, prefixed_linetypes_array, pdf)

        #if not enough on page start new page
        if pdf.y >= 14.mm
          pdf.y = y_position
        else
          page_break(project, line, pdf)
        end

        #if first clause of clausetype, insert clause type title
        clausetype_print(project, subsection, clausetype, pdf) if i == 0

        #print line
        #print_author(user_array.index?(line.user_id), line.update_at, pdf) if issue == "audit"
        line_print(project, line, pdf)
        pdf.move_down(pdf.box_height + 2.mm)
      end
    end

end


def print_line_space_check(line, i, clausetype_speclines, prefixed_linetypes_array, pdf)
        #if line is clause title
        if i == 0
          pdf.move_down(16.mm)
        end

        #check line
        line_draft(line, pdf)
        pdf.move_down(pdf.draft_box_height + 2.mm)

        #establish if clause title will fit on the page when:
        #- at least one line of the clause will fit below it
        #- if the second line in the clause is prefixed, it will also fit on page
        #if none of the above can be achieved then start new page
                
        #if line is a clause title
        if line.clause_line == 0;
          #if there is 1st line in clause
          if !clausetype_speclines[i+1].blank?
            #if 1st line is part of same clause
            if clausetype_speclines[i+1].clause_line == 1
              #check line fits
              line_draft(clausetype_speclines[i+1], pdf)
              pdf.move_down(pdf.draft_box_height + 2.mm)
              #if 1st line does not have a prefix
              if !prefixed_linetypes_array.include?(clausetype_speclines[i+1].linetype_id)
                #if 2nd line exists
                if !clausetype_speclines[i+2].blank?
                  #if 2nd line is part of same clause
                  if clausetype_speclines[i+2].clause_line == 2
                    #if 2nd line is prefixed - check 2nd line also fits
                    if prefixed_linetypes_array.include?(clausetype_speclines[i+2].linetype_id)
                      #check line fits
                      line_draft(clausetype_speclines[i+2], pdf)
                      pdf.move_down(pdf.draft_box_height + 2.mm)
                    end
                  end
                end
              end
            end
            #if 1st line is also a clause title
            if clausetype_speclines[i+1].clause_line == 0
              #if 2nd line exists 
              if !clausetype_speclines[i+2].blank?
                #if 2nd line is part of same clause
                if clausetype_speclines[i+2].clause_line == 1
                  #check line fits
                  line_draft(clausetype_speclines[i+2], pdf)
                  pdf.move_down(pdf.draft_box_height + 2.mm)
                  #if 2nd line does not have a prefix
                  if !prefixed_linetypes_array.include?(clausetype_speclines[i+2].linetype_id)
                    #if 3rd line exists
                    if !clausetype_speclines[i+3].blank?
                      #if 3rd line is part of same clause
                      if clausetype_speclines[i+3].clause_line == 2
                        #if 3rd line is prefixed - check 2nd line also fits
                        if prefixed_linetypes_array.include?(clausetype_speclines[i+3].linetype_id)
                          #check line fits
                          line_draft(clausetype_speclines[i+3], pdf)
                          pdf.move_down(pdf.draft_box_height + 2.mm)
                        end
                      end
                    end  
                  end
                end  
              end
            end
          end
        end
end


def page_break(project, line, pdf)
  if line.clause_line == 0
    pdf.start_new_page
    pdf.y = 268.mm 
  else  
    clausetitle_continued(line, pdf)  
    pdf.start_new_page
    pdf.y = 268.mm
      
    clausetitle_repeat(project, line, pdf)
    pdf.move_down(pdf.box_height + 2.mm) 
  end   
end


def clausetype_print(project, subsection, clausetype, pdf)
#font styles for page  
  font_style_clausetype_code = {:size => 11, :style => :bold}
#formating for lines  
  clausetype_code_format = font_style_clausetype_code
  clausetype_title_format = font_style_clausetype_code.merge(:width => 155.mm, :overflow => :expand)

      pdf.move_down(6.mm)
#TODO replace ref system code options
#TODO reset start point to allow for audit and uniclass code width
      if project.CAWS?
        pdf.spec_box subsection.full_code + '.' + clausetype.id.to_s + '000', clausetype_code_format.merge(:at =>[0.mm, pdf.y])
      else
        pdf.spec_box subsection.full_code + '.' + clausetype.id.to_s + '000', clausetype_code_format.merge(:at =>[0.mm, pdf.y])
      end
#TODO reset start point to allow for audit and uniclass code width
      pdf.spec_box clausetype.text.upcase, clausetype_title_format.merge(:at =>[20.mm, pdf.y])
      pdf.move_down(pdf.box_height)
end



def line_draft(line, pdf)
#font styles for lines
  font_style_clause_title = {:size => 11, :style => :bold}
  font_style_specline = {:size => 10}
#formating for lines  
#TODO reset start point to allow for audit and uniclass code width
  clausetitle_format = font_style_clause_title.merge(:width => 155.mm, :overflow => :expand)
  prefixed_specline_format = font_style_specline.merge(:width => 140.mm, :overflow => :expand)
  specline_format = font_style_specline.merge(:width => 149.mm, :overflow => :expand)

#TODO reset start point to allow for audit and uniclass code width
    case line.linetype_id
      when 1, 2 ;   draft_linetype_1_helper(line, clausetitle_format, pdf)
      when 3 ;      pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", prefixed_specline_format.merge(:at =>[30.mm, pdf.y])
      when 4 ;      pdf.draft_text_box "#{line.txt4.text}", prefixed_specline_format.merge(:at =>[30.mm, pdf.y])
      when 7 ;      pdf.draft_text_box "#{line.txt4.text}", specline_format.merge(:at =>[23.mm, pdf.y])
      when 8 ;      pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[23.mm, pdf.y])
      when 10 ;     draft_linetype_8_helper(line, specline_format, pdf)
      when 11 ;     pdf.draft_text_box "#{line.perform.performkey.text}: #{line.identity.perform.performvalue.full_perform_value}", specline_format.merge(:at =>[23.mm, pdf.y])
      when 12 ;     pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[23.mm, pdf.y])
    end
end

def draft_linetype_1_helper(line, clausetitle_format, pdf)
#TODO reset start point to allow for audit and uniclass code width
     pdf.move_down(4.mm)
     pdf.draft_text_box "#{line.clause.clausetitle.text}", clausetitle_format.merge(:at =>[20.mm, pdf.y]) 
end

def draft_linetype_10_helper(line, specline_format, pdf)
#TODO reset start point to allow for audit and uniclass code width
  if line.identity.identkey.text == "Manufacturer"
      pdf.draft_text_box "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_address}", specline_format.merge(:at =>[23.mm, pdf.y]) 
  else
      pdf.draft_text_box "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}", specline_format.merge(:at =>[23.mm, pdf.y]) 
  end
end



def line_print(project, line, pdf)

#font styles for lines
  font_style_clause_title = {:size => 11, :style => :bold}
  font_style_specline = {:size => 10}


#formating for lines
#TODO reset start point to allow for audit and uniclass code width
  clausetitle_format = font_style_clause_title.merge(:width => 155.mm,:overflow => :expand)
  specline_prefix_format = font_style_specline.merge(:width => 4.mm)
  prefixed_specline_format = font_style_specline.merge(:width => 140.mm,:overflow => :expand)
  indent_format = font_style_specline.merge(:width => 3.mm) 
  specline_format = font_style_specline.merge(:width => 149.mm,:overflow => :expand)

    case line.linetype_id
      when 1, 2 ;   print_linetype_1_helper(project, line, clausetitle_format, pdf)
      when 3 ;      print_linetype_3_helper(line, specline_prefix_format, prefixed_specline_format, pdf)
      when 4 ;      print_linetype_4_helper(line, specline_prefix_format, prefixed_specline_format, pdf)
      when 7 ;      print_linetype_7_helper(line, indent_format, specline_format, pdf)
      when 8 ;      print_linetype_8_helper(line, indent_format, specline_format, pdf)
      when 10 ;     print_linetype_10_helper(line, indent_format, specline_format, pdf)
      when 11 ;     print_linetype_11_helper(line, indent_format, specline_format, pdf)
      when 12 ;     print_linetype_12_helper(line, indent_format, specline_format, pdf)

    end
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_1_helper(project, line, specline_format, pdf)
     pdf.move_down(4.mm)
     pdf.spec_box "#{full_clause_code(project, line)}", specline_format.merge(:at =>[0.mm, pdf.y]) 
     pdf.spec_box "#{line.clause.clausetitle.text}", specline_format.merge(:at =>[20.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_3_helper(line, prefix_format, specline_format, pdf)
    pdf.spec_box "#{line.txt1.text}.", prefix_format.merge(:at => [26.mm, pdf.y])
    pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[30.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_4_helper(line, prefix_format, specline_format, pdf)
    pdf.spec_box "#{line.txt1.text}.", prefix_format.merge(:at => [26.mm, pdf.y])
    pdf.spec_box "#{line.txt4.text}", specline_format.merge(:at =>[30.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_7_helper(line, indent_format, specline_format, pdf)
    pdf.spec_box '-', indent_format.merge(:at => [20.mm, pdf.y]) 
    pdf.spec_box "#{line.txt4.text}", specline_format.merge(:at =>[23.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_8_helper(line, indent_format, specline_format, pdf)
    pdf.spec_box '-', indent_format.merge(:at => [20.mm, pdf.y]) 
    pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[23.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_10_helper(line, indent_format, specline_format, pdf)
    pdf.spec_box '-', indent_format.merge(:at => [20.mm, pdf.y]) 
    if line.identity.identkey.text == "Manufacturer"  
      pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_name}", specline_format.merge(:at =>[23.mm, pdf.y])  
    else
      pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}", specline_format.merge(:at =>[23.mm, pdf.y])  
    end
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_11_helper(line, indent_format, specline_format, pdf)
    pdf.spec_box '-', indent_format.merge(:at => [20.mm, pdf.y]) 
    pdf.spec_box "#{line.perform.performkey.text}: #{line.identity.perform.performvalue.full_perform_value}", specline_format.merge(:at =>[23.mm, pdf.y]) 
end

#TODO reset start point to allow for audit and uniclass code width
def print_linetype_12_helper(line, indent_format, specline_format, pdf)
    pdf.spec_box '-', indent_format.merge(:at => [20.mm, pdf.y]) 
    pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", specline_format.merge(:at =>[23.mm, pdf.y]) 
end


def print_revision_author(ref, date, pdf)
    pdf.spec_box "#{ref}:#{line.updated_at.strftime("%d/%m/%y")}", {:size => 8, :at => [10.mm, pdf.y], :width => 17.mm}
end

#TODO reset start point to allow for audit and uniclass code width
def clausetitle_continued(line, pdf)
     pdf.spec_box 'Clause continued on next page...', :size => 9, :style => :italic, :at =>[20.mm, 16.mm], :width => 155.mm, :overflow => :expand
end

#TODO reset start point to allow for audit and uniclass code width
def clausetitle_repeat(project, line, pdf)
     pdf.spec_box full_clause_code(project, line), :size => 10, :style => :bold_italic, :at =>[0.mm, pdf.y], :width => 20.mm, :height => 5.mm
     pdf.spec_box line.clause.clausetitle.text + ' (continued)', :size => 10, :style => :bold_italic, :at =>[20.mm, pdf.y], :width => 155.mm, :overflow => :expand
end


def full_clause_code(project, line)
    line.clause.clauseref.subsection.method(set_subsection_name(project)).call.full_code + '.' + line.clause.clauseref_code
end

end