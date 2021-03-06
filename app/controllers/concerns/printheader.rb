module Printheader

def header(project, settings, header_page_start, header_page_end, pdf)  
  
  pdf.line_width(0.1)

  pdf.repeat(header_page_start..header_page_end) do
      
    header_contents(project, settings, pdf)
        
    pdf.stroke do
      pdf.line [0.mm,274.mm],[176.mm,274.mm]
    end
  end
end



def header_contents(project, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.role' => "owner", 'projectusers.project_id' => project.id).first

#font styles for page  
  header_style = {:size => 8}
#formating for lines  
  header_format = header_style.merge(:align => :left)

  pdf.y = 285.mm

  if settings.header_client == "show" 
    pdf.spec_box "#{project.client_name}", header_format.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height + 1.mm)
  end 

  if settings.header_project == "show" 
    pdf.spec_box "#{project.title}", header_format.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height + 1.mm)
  end    
    
  if settings.header_document == "show" 
    pdf.spec_box "Architectural Specification", header_format.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height + 1.mm)
  end    


  if settings.header_logo != "none" 
  
    if settings.header_logo == "author" 
      pdf.image company.logo.path, :position => :right, :vposition => -12.mm, :align => :right, :fit => [250,25]
    end
    if settings.header_logo == "client" 
      pdf.image project.client_logo.path, :position => :right, :vposition => -12.mm, :align => :right, :fit => [250,25]
    end
  end 
      
end

end
