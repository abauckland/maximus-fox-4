module SpecificationsHelper

  def authorise_specline_view(permissible_roles)
    if permissible_roles.include?(@current_user.role)
      return true
    end
  end

  def clause_link(project_id, subsection_id)
      "<div class='guide_download_button'>#{link_to '+/- clauses', {:controller => "specclauses", :action => "manage", :id => project_id, :project_id => project_id, :subsection_id => subsection_id}}</div>".html_safe
  end

  ##specline table formatting
  def specline_table(specline)
    @line = specline
      
      case specline.linetype_id
        #clause title
        when 1, 2 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{clause_code(specline)}  <td class='edit_clause_title'>#{specline.clause.clausetitle.text}</td> #{suffix_clause_menu(specline)}</table>".html_safe
        #prefixed - editable text    
        when 3 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_letter_prefix(specline)} <td class='text_text'> #{txt4(specline)}:  #{txt5(specline)} </td> #{suffix_menus(specline)} </table>".html_safe
        #prefixed - editable text: editable text
        when 4 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_letter_prefix(specline)} <td class='text_text'> #{txt4(specline)} </td> #{suffix_menus(specline)} </table>".html_safe
        #                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
        when 5 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_prefix} <td><table><tr><td class='text_text'> #{txt3(specline)} </td><td>:</td><td width = '5'></td><td> #{txt6(specline)} </td></tr></table></td> #{suffix_menus(specline)} </table>".html_safe
        #
        when 6 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_prefix} <td><table><tr><td class='text_text'> #{txt3(specline)} </td><td>:</td><td width = '5'></td><td> #{txt5(specline)} </td></tr></table></td> #{suffix_menus(specline)} </table>".html_safe
        #editable text
        when 7 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_prefix} <td class='text_text'> #{txt4(specline)} </td> #{suffix_menus(specline)} </table>".html_safe
        #editable text: editable text                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
        when 8 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_row'> #{prefix_menu(specline)}  #{line_prefix} <td class='text_text'> #{txt4(specline)}:  #{txt5(specline)} </td> #{suffix_menus(specline)} </table>".html_safe
        #product identity pair text
        when 10 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_data_row'> #{prefix_menu_data(specline)}  #{line_prefix}  #{identity_pair(specline)} #{suffix_menus(specline)} </table>".html_safe
        #product peform pair text
        when 11 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_data_row'> #{prefix_menu_data(specline)}  #{line_prefix}  #{perform_pair(specline)} #{suffix_menus(specline)} </table>".html_safe
        #cross reference
        when 12 ; "<table id='#{specline.id}' class='specline_table' width='100%'><tr class='specline_xref_row'> #{prefix_menu_xref(specline)}  #{line_prefix}  #{xref(specline)}  #{suffix_menus(specline)} </table>".html_safe   
        #product information (not linked to product database)
  #     when 13 ; "#{html_prefix(specline)}  <td class='prefix' width='10px'>-</td><td class='text_text'><span id='#{specline.id}'class='editable_text4'>#{specline.txt4.text}</span>: <span id='#{specline.id}'class='editable_text5'>#{specline.txt5.text}</span></td>   <td class='suffixed_line_menu_mob'>#{specline_mob_spec_menu(specline)}</td>#{specline_links(specline)}</tr><tr class='specline_mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{specline_suffix_menu_mob_spec(specline)}</td></tr></table>".html_safe

      end
  end


  #line prefix menues
  def clause_code(specline)
      "<td class='edit_clause_code'>#{spec_clause_ref_text(specline)}</td>".html_safe
  end

  def prefix_menu(specline)
  #    if authorise_specline_view(['manage', 'edit', 'write'])
      "<td class='prefixed_line_space'></td><td class='prefixed_line_menu'>#{specline_move}</td>".html_safe
  #  else
  #    "<td class='prefixed_line_space'></td><td class='prefixed_line_menu'></td>".html_safe
  #  end
  end

  def prefix_menu_data(specline)
      "</td><td class='prefixed_line_menu'></td>".html_safe
  end

  def prefix_menu_xref(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "</td><td class='prefixed_line_menu'>#{specline_move}</td>".html_safe
  #  else
  #    "</td><td class='prefixed_line_menu'></td>".html_safe
  #  end
  end


  #line prefixes
  def line_prefix
      "<td class='prefix' width='10px'>-</td>".html_safe
  end

  def line_letter_prefix(specline)
      "<td width='10px'></td><td class='text_prefix' width='18'>#{specline.txt1.text}.</td>".html_safe  
  end


  def txt3(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<span id='#{specline.id}' class='editable_text3'>#{specline.txt3.text}</span>".html_safe
  #  else
  #    "#{specline.txt3.text}".html_safe
  #  end
  end

  def txt4(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<span id='#{specline.id}' class='editable_text4'>#{specline.txt4.text}</span>".html_safe
  #  else
  #    "#{specline.txt4.text}".html_safe
  #  end
  end

  def txt5(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<span id='#{specline.id}' class='editable_text5'>#{specline.txt5.text}</span>".html_safe
  #  else
  #    "#{specline.txt5.text}".html_safe
  #  end
  end

  def txt6(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<span id='#{specline.id}' class='editable_text6'>#{specline.txt6.text}</span>".html_safe
  #  else
  #    "#{specline.txt6.text}".html_safe
  #  end
  end


  def identity_pair(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      if specline.identity.identkey.text == "Manufacturer"
      "<td class='data_key'><span id='#{specline.id}'class='editable_product_key'>#{specline.identity.identkey.text}</span>: <span id='#{specline.id}'class='editable_product_value'>#{specline.identity.identvalue.company.details}</span></td>".html_safe
      else
      "<td class='data_key'><span id='#{specline.id}'class='editable_product_key'>#{specline.identity.identkey.text}</span>: <span id='#{specline.id}'class='editable_product_value'>#{specline.identity.identvalue.identtxt.text}</span></td>".html_safe  
      end
  #  else
  #    if specline.identity.identkey.text == "Manufacturer"
  #      "<td class='data_key'>#{specline.identity.identkey.text}: #{specline.identity.identvalue.company.details}</td>".html_safe  
  #    else  
  #      "<td class='data_key'>#{specline.identity.identkey.text}: #{specline.identity.identvalue.identtxt.text}</td>".html_safe
  #    end
  #  end
  end

  def perform_pair(specline) 
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<td class='text_text'><span id='#{specline.id}'class='editable_product_key'>#{specline.perform.performkey.text}</span>: <span id='#{specline.id}'class='editable_product_value'>#{specline.perform.performvalue.value_with_units}</span></td>".html_safe
  #  else
  #    "<td class='text_text'>#{specline.perform.performkey.text}: #{specline.perform.performvalue.full_perform_value}</td>".html_safe    
  #  end
  end
  
  
  def xref(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<td class='text_text'><span id='#{specline.id}'class='editable_text4'>#{specline.txt4.text}</span>: <span id='#{specline.id}'class='editable_xref'>#{specline.txt5.text}</span></td>".html_safe
  #  else
  #    "<td class='text_text'>#{specline.txt4.text}: #{specline.txt5.text}</td>".html_safe
  #  end
  end


  def suffix_menus(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<td class='suffixed_line_menu_mob'>#{specline_mob_spec_menu(specline)}</td>#{specline_links(specline)}</tr><tr class='specline_mob_menu_popup'><td class='mob_line_menu' colspan=3 >#{specline_suffix_menu_mob_spec(specline)}</td>".html_safe
  #  else
  #    "<td class='suffixed_line_menu_mob'></td><td class='suffixed_line_menu'></td>".html_safe
  #  end
  end

  def suffix_clause_menu(specline)
  #  if authorise_specline_view(['manage', 'edit', 'write'])
      "<td class='suffixed_line_menu_mob'>#{specline_mob_clause_menu(specline)}</td><td class='suffixed_line_menu' width ='120'>#{clause_help_link(specline)}#{clause_delete_link(specline)}#{clause_new_link(specline)}#{specline_line_new_link(specline)}</td></tr><tr class='specline_mob_menu_popup'><td class='mob_line_menu' colspan=2 >#{specline_suffix_menu_mob_clause(specline)}</td></tr>".html_safe
  #  else
  #    "<td class='suffixed_line_menu_mob'></td><td class='suffixed_line_menu'></td>".html_safe
  #  end
  end



  def specline_move
      image_tag("move.png", :mouseover => "move_rollover.png", :border=>0, :title => 'drag & drop')
  end

  def specline_mob_spec_menu(specline)
      image_tag("menu.png", :mouseover =>"menu_rollover.png", :border=>0, :title => 'click for menu')
  end

  def specline_mob_clause_menu(specline)
      image_tag("menu.png", :mouseover =>"menu_rollover.png", :border=>0, :title => 'click for menu')
  end

  def specline_links(specline)
     "<td class='suffixed_line_menu'>#{specline_line_delete_link(specline)}#{specline_line_edit_link(specline)}#{specline_line_new_link(specline)}#{clause_manufact_link(specline)}  </td>".html_safe
  end

  def specline_suffix_menu_mob_clause(specline)
     "#{clause_help_link(specline)}#{clause_delete_link(specline)}#{clause_new_link(specline)}#{specline_line_new_link(specline)}".html_safe
  end

  def specline_suffix_menu_mob_spec(specline) 
     "#{clause_manufact_link(specline)}#{specline_line_delete_link(specline)}#{specline_line_edit_link(specline)}#{specline_line_new_link(specline)}".html_safe
  end


  def spec_clause_ref_text(specline)
    if @project.ref_system == "CAWS"
      specline.clause.clauseref.subsection.cawssubsection.cawssection.ref + sprintf("%02d", specline.clause.clauseref.subsection.cawssubsection.ref).to_s<<"."<<specline.clause.clauseref.clausetype_id.to_s<<sprintf("%02d", specline.clause.clauseref.clause_no).to_s<<specline.clause.clauseref.subclause.to_s 
    else
      specline.clause.clauseref.subsection.unisubsection.unisection.ref + sprintf("%02d", specline.clause.clauseref.subsection.unisubsection.ref).to_s<<"."<<specline.clause.clauseref.clausetype_id.to_s<<sprintf("%02d", specline.clause.clauseref.clause_no).to_s<<specline.clause.clauseref.subclause.to_s     
    end
  end

  def clause_new_link(specline)
    link_to "", manage_specclause_path(:id => specline.project_id, :project_id => specline.project_id, :subsection_id => specline.clause.clauseref.subsection_id), :class => "line_new_icon", :title => "add/delete clauses"

  end

  def clause_delete_link(specline)
    link_to "", delete_clause_specline_path(specline.id), method: :delete, :remote => true, :class => "line_delete_icon", :title => "delete clause"
  end

  def specline_line_new_link(specline)
    link_to "", new_specline_specline_path(specline.id), :remote => true, :class => "line_insert_icon", :title => "insert clause line"
  end

  def specline_line_edit_link(specline)
    link_to "", edit_specline_path(specline.id), :remote => true, :class => "line_edit_icon", :title => "change line format"
  end

  def specline_line_delete_link(specline)
    link_to "", delete_specline_specline_path(specline.id), method: :delete, :remote => true, :class => "line_delete_icon", :title => "delete line"
  end

  def clause_help_link(specline)  
    if !specline.clause.guidenote.nil?
      link_to "", guidance_specline_path(specline.id), :remote => true, :class => "line_info_icon", :title => "clause guidance"
    end
  end


  def clause_manufact_link(specline)
  end

end
