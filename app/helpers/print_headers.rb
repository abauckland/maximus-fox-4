#header_contents
#=> client name
#=> company name
#=> project code, title, revision & status
#=> company logo/client logo
#=>

#header_style
#=> none
#=> left_aligned
#=> right_aligned
#=> center_aligned

def header(project, pdf)  
  
  pdf.line_width(0.1)

  pdf.repeat :omit_first_page do
      
    header_contents(project, pdf)
        
    pdf.stroke do
      pdf.line [0.mm,273.mm],[176.mm,273.mm]
    end
  end
end



def header_contents(project, pdf)
    if !company.photo_file_name.blank?
      pdf.image "#{Rails.root}/public#{company.photo.url.sub!(/\?.+\Z/, '') }", :position => :right, :vposition => -11.mm, :align => :right, :fit => [250,25]
    end

  if project.style.client_name != false
    pdf.text_box "#{current_project.title}", :size => 9, :at => [0,pdf.bounds.top + 5.mm], :align => :left
  end 

  if project.style.company_name != false
    pdf.text_box "#{current_project.title}", :size => 9, :at => [0,pdf.bounds.top + 5.mm], :align => :left
  end     
    
  if project.style.project_details != false
    pdf.text_box "#{current_project.title}", :size => 9, :at => [0,pdf.bounds.top + 5.mm], :align => :left
  end    
      
end
