module Printuserlist

  def page_userlist(data, pdf)
    page_userlist_header(pdf)
    index_userlist(data, pdf)
  end


  def page_userlist_header(pdf)
    page_title = {:size => 16, :style => :bold}

    pdf.move_down(11)
    pdf.text "Author/Editor Key", page_title
    pdf.move_down(20)
  end

  def index_userlist(data, pdf)

    rows = []
    rows[0] = userlist_headers
    userlist_data(data, rows)

    pdf.table(rows, :header => true,
                    :column_widths => column_widths(index),
                    :cell_style => {:padding => [2.mm, 2.mm, 2.mm, 2.mm], :border_width => [0,0,0,0], :size => 8}
                    )
  end



  def userlist_headers
    ["Reference", "User Email", "Name", "Company"]
  end

  def userlist_column_widths
    [60.mm, 120.mm, 80.mm, 80.mm]
  end

  def userlist_data(data, rows)
        data.each_with_index do |set, i|

          rows[i+1] = [
                       i.to_s,
                       set.email,
                       set.name,
                       set.company.name,
                       ]
      end
  end

end