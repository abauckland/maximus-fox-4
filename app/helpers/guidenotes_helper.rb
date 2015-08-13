module GuidenotesHelper

  def guidenote_in_use(guidenote)

    clauseguide = Clauseguide.where(:guidenote_id => guidenote.id).first

    if clauseguide.blank?
      link_to '', guidenote_path(guidenote), method: :delete, class: 'line_edit_icon', title: "delete guidenote"
    end
  end

end