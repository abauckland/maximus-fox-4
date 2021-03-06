module Printrevision

def section_revisions(project, revision, issue, pdf)

#TODO change out caws refrences
  subsections = Subsection.joins(:cawssubsection => [:cawssection], :clauserefs => [:clauses => :alterations]
                      ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
                      ).order('cawssections.ref, cawssubsections.ref'
                      ).uniq

  subsections.each_with_index do |subsection, i|

    alteration = Alteration.joins(:clause => :clauseref
                                 ).where(:project_id => project.id, :revision_id => revision.id, :clause_add_delete => 3, 'clauserefs.subsection_id' => subsection.id
                                 ).where.not(:event => 'changed'
                                 ).first

    if alteration
      #check space available
      check_height = (section_title_height + section_action_height)
      #unless space
      y_position = pdf.y
      if (y_position - check_height) < 13.mm
        pdf.start_new_page
        pdf.y = 268.mm
      end
      #end
      print_section_title(subsection, i, pdf)
#if print_audit == true
#  ref = user_array.index?(alteration.user_id)
#  print_revision_author(ref, date, print_audit, pdf)
#end
      print_section_action(alteration, pdf)

    else
      clause_revisions(subsection, project, revision, i, pdf)
    end
  end

end



def clause_revisions(subsection, project, revision, i, pdf)

  clauses = Clause.joins(:alterations, :clauseref
                      ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id, 'clauserefs.subsection_id' => subsection.id
                      ).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                      ).uniq

  clauses.each_with_index do |clause, n|

    alteration = Alteration.where(:project_id => project.id, :revision_id => revision.id, :clause_id => clause.id, :clause_add_delete => 2 
                             ).where.not(:event => 'changed'
                             ).first

    if alteration
      #check space available with title
      check_height = (clause_title_height + clause_action_height)
      check_height += section_title_height if n == 1
      #unless space
      y_position = pdf.y
      if (y_position - check_height) < 13.mm
        pdf.start_new_page
        pdf.y = 268.mm
      end
      #end
      print_section_title(subsection, i, pdf) if n == 1
      print_clause_title(clause, n, pdf)
#if print_audit == true
#  ref = user_array.index?(alteration.user_id)
#  print_revision_author(ref, date, print_audit, pdf)
#end
      print_clause_action(alteration, pdf)

    else
      #print changed clauses
      line_revisions(clause, subsection, project, revision, i, n, pdf)
    end
  end

end



  def line_revisions(clause, subsection, project, revision, i, n, pdf)

    @previous_lines = false

    new_lines = Alteration.where(:project_id => project.id, :revision_id => revision.id, :clause_id => clause.id, :clause_add_delete => 1 
                         ).where(:event => 'new').uniq

    new_lines.each_with_index do |line, m|

      check_height = check_text_height(line, pdf) + 2.mm
      check_titles_height(check_height, m, n, @previous_lines, pdf)

      check_page_position(check_height, m, pdf)

      print_clause_rev_titles(subsection, clause, line, i, m, n, @previous_lines, pdf)
#      if print_audit == true
#        ref = user_array.index?(line.user_id)
#        print_revision_author(ref, date, print_audit, pdf)
#      end
      line_text(line, pdf)
    end
    pdf.move_down(2.mm)
    @previous_lines = true if !new_lines.blank?


    deleted_lines = Alteration.where(:project_id => project.id, :revision_id => revision.id, :clause_id => clause.id, :clause_add_delete => 1 
                             ).where(:event => 'deleted').uniq

    deleted_lines.each_with_index do |line, m|

      check_height = check_text_height(line, pdf) + 2.mm
      check_titles_height(check_height, m, n, @previous_lines, pdf)

      check_page_position(check_height, m, pdf)

      print_clause_rev_titles(subsection, clause, line, i, m, n, @previous_lines, pdf)
#      if print_audit == true
#        ref = user_array.index?(line.user_id)
#        print_revision_author(ref, date, print_audit, pdf)
#      end
      line_text(line, pdf)
    end
    pdf.move_down(2.mm)
    @previous_lines = true if !deleted_lines.blank?


    changed_lines = Alteration.where(:project_id => project.id, :revision_id => revision.id, :clause_id => clause.id, :clause_add_delete => 1 
                             ).where(:event => 'changed').uniq

    changed_lines.each_with_index do |line, m|

      current_line = Specline.find(line.specline_id)

      check_height = check_text_height(line, pdf) + 2.mm
      check_height += check_text_change_height(current_line, pdf)
      check_titles_height(check_height, m, n, @previous_lines, pdf)

      check_page_position(check_height, m, pdf)

      print_clause_rev_titles(subsection, clause, line, i, m, n, @previous_lines, pdf)
#      if print_audit == true
#        ref = user_array.index?(line.user_id)
#        print_revision_author(ref, date, print_audit, pdf)
#      end
      clause_line_state_from(pdf)
      changed_line_text_from(line, pdf)
      clause_line_state_to(pdf)
      changed_line_text_from(current_line, pdf)

      pdf.move_down(2.mm)
    end
  end


  def check_titles_height(check_height, m, n, previous_lines, pdf)
    if m ==0
      check_height += section_title_height if n == 0 && previous_lines == false
      check_height += clause_title_height if previous_lines == false
      check_height += line_title_height
    end
  end

  def check_page_position(check_height, m, pdf)
    y_position = pdf.y
    if (y_position - check_height) < 13.mm
      continue_text(pdf) if m !=0
      pdf.start_new_page 
      pdf.y = 268.mm
      continuation_text(pdf) if m !=0
    end
  end

  def print_clause_rev_titles(subsection, clause, line, i, m, n, previous_lines, pdf)
    if m ==0
      print_section_title(subsection, i, pdf) if n == 0 && previous_lines == false
      print_clause_title(clause, n, pdf) if previous_lines == false
      print_clause_line_action(line, pdf)
    end
  end


#draft lines heights
  def section_title_height
    return 12.mm
  end

  def section_action_height
    return 8.mm
  end

  def clause_title_height #could be wider than page width
    return 9.mm
  end

  def clause_action_height
    return 8.mm
  end

  def line_title_height
    return 8.mm
  end

  def line_action_height
    return 8.mm
  end

  def check_text_height(line, pdf)

    style = {:size => 10, :width => 147.mm, :overflow => :expand}

    case line.linetype_id
      when 4, 7 then pdf.draft_text_box "#{line.txt4.text}", style
      when 3, 8, 12 then pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", style
    end
    return pdf.draft_box_height
  end

  def check_text_change_height(line, pdf)

    style = {:size => 10, :width => 139.mm, :overflow => :expand}

    case line.linetype_id
      when 4, 7 then pdf.draft_text_box "#{line.txt4.text}", style
      when 3, 8, 12 then pdf.draft_text_box "#{line.txt4.text}: #{line.txt5.text}", style
    end
    return pdf.draft_box_height
  end


  def print_section_title(section, i, pdf)
    rev_section_title_style = {:size => 12, :style => :bold}

    pdf.move_down(8.mm) if i != 0
    pdf.spec_box section.method(set_subsection_name(@project)).call.full_code, rev_section_title_style.merge(:at => [10.mm, pdf.y])
    pdf.spec_box section.method(set_subsection_name(@project)).call.title, rev_section_title_style.merge(:at => [20.mm, pdf.y])
    pdf.move_down(pdf.box_height)
  end


  def print_section_action(line, pdf)
    rev_text_style = {:size => 10, :overflow => :expand}

    pdf.move_down(4.mm)
    if line.event == "new"
      pdf.spec_box "Section added", rev_text_style.merge(:at => [20.mm, pdf.y])
    end
    if line.event == "deleted"
      pdf.spec_box "Section deleted", rev_text_style.merge(:at => [20.mm, pdf.y])
    end
    pdf.move_down(pdf.box_height)
  end


  def print_clause_title(clause, n, pdf)
    rev_clause_title_style = {:size => 10, :style => :bold, :overflow => :expand}

    if n == 0
      pdf.move_down(2.mm)
    else
      pdf.move_down(2.mm)
    end
    pdf.spec_box clause_code(clause), rev_clause_title_style.merge(:at => [20.mm, pdf.y])
    pdf.spec_box clause.clause_title, rev_clause_title_style.merge(:at => [38.mm, pdf.y])
    pdf.move_down(pdf.box_height)
  end


  def print_clause_action(line, pdf)

    clause_action_text = "Clause "+ line.event

    pdf.move_down(2.mm)
    pdf.spec_box clause_action_text, {:at => [27.mm, pdf.y], :size => 10, :style => :italic, :overflow => :expand}
    pdf.move_down(pdf.box_height)
  end


  def print_clause_line_action(line, pdf)

    line_action_text = "Text " + line.event

    pdf.move_down(2.mm)
    pdf.spec_box line_action_text, {:at => [27.mm, pdf.y], :size => 10, :style => :italic}
    pdf.move_down(pdf.box_height)
  end


  def clause_line_state_from(pdf)
    rev_state_style = {:size => 10, :style => :italic}

    pdf.move_down(2.mm)
    pdf.spec_box "from:", rev_state_style.merge(:at => [34.mm, pdf.y])
#    pdf.move_up(pdf.box_height + 2.mm)
  end


  def clause_line_state_to(pdf)
    rev_state_style = {:size => 10, :style => :italic}

#    pdf.move_down(2.mm)
    pdf.spec_box "to:", rev_state_style.merge(:at => [34.mm, pdf.y])
#    pdf.move_up(pdf.box_height + 2.mm)
  end


  def line_text(line, pdf)
    rev_text_style = {:size => 10, :overflow => :expand}

    pdf.move_down(2.mm)
  #  pdf.spec_box '-', indent_format.merge(:at => [32.mm, pdf.y])
    rev_text_style = rev_text_style.merge(:at => [34.mm, pdf.y], :width => 149.mm)
    rev_line_print(line, rev_text_style, pdf)
    pdf.move_down(pdf.box_height)
  end


  def changed_line_text_from(line, pdf)
    rev_text_style = {:size => 10, :overflow => :expand}

#    pdf.move_down(2.mm)
    rev_text_style = rev_text_style.merge(:at => [45.mm, pdf.y], :width => 139.mm)
    rev_change_line_print(line, rev_text_style, pdf)
    pdf.move_down(pdf.box_height + 1.mm)
  end


  def changed_line_text_to(line, pdf)
    rev_text_style = {:size => 10, :overflow => :expand}

#    pdf.move_down(2.mm)
    style = rev_text_style.merge(:at => [45.mm, pdf.y], :width => 124.mm)
    rev_change_line_print(line, rev_text_style, pdf)
    pdf.move_down(pdf.box_height)
  end


  def rev_line_print(line, style, pdf)
    pdf.spec_box '-', {:at => [34.mm, pdf.y], :width => 3.mm}
    case line.linetype_id
      when 4, 7 then pdf.spec_box "#{line.txt4.text}", style.merge(:at => [37.mm, pdf.y], :width => 147.mm)
      when 3, 8, 10, 11, 12 then pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", style.merge(:at => [37.mm, pdf.y], :width => 147.mm)
    end
  end

  def rev_change_line_print(line, style, pdf)
    case line.linetype_id
      when 4, 7 then pdf.spec_box "#{line.txt4.text}", style
      when 3, 8, 10, 11, 12 then pdf.spec_box "#{line.txt4.text}: #{line.txt5.text}", style
    end
  end

  def continue_text(pdf)
    pdf.spec_box "list of changes continued on next page", {:size => 9, :style => :italic}
  end

  def continuation_text(pdf)
    pdf.spec_box "list of changes continued from previous page", {:size => 9, :style => :italic}
  end

  #def rev_print_linetype_10_helper(line, style, pdf)
  #  if line.identity.identkey.text == "Manufacturer"
  #    pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.company.company_name}", style
  #  else
  #    pdf.spec_box "#{line.identity.identkey.text}: #{line.identity.identvalue.identtxt.text}", style
  #  end
  #end

  #def rev_print_linetype_11_helper(line, style, pdf)
  #  pdf.spec_box "#{line.perform.performkey.text}: #{line.identity.perform.performvalue.full_perform_value}", style
  #end


  def print_revision_author(ref, date, pdf)
      pdf.spec_box "#{ref}:#{date.strftime("%d/%m/%y")}", {:size => 8, :at => [10.mm, pdf.y], :width => 17.mm}
  end

  def clause_code(clause)
      clause.clauseref.subsection.method(set_subsection_name(@project)).call.full_code + '.' + clause.clauseref_code
  end

end