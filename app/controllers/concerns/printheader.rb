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
  client = Client.where(:project_id => project.id).first
#font styles for page  
  header_style = {:size => 8}
#formating for lines  
  header_format = header_style.merge(:align => :left)

  pdf.y = 285.mm

  if settings.header_client == "show" 
    pdf.spec_box "#{client.name}", header_format.merge(:at =>[0.mm, pdf.y])
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


  if settings.header_logo == "show" 
  
    case settings.header_logo
      when "company" ; url = company.logo 
      when "client" ; url = client.client_logo
    end
    if url  
      pdf.image url, :position => :right, :vposition => -11.mm, :align => :right, :fit => [250,25]
    end
  end 
      
end

end
