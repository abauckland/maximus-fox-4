module Printheader

def header(project, settings, pdf)  
  
  pdf.line_width(0.1)

  pdf.repeat :omit_first_page do
      
    header_contents(project, settings, pdf)
        
    pdf.stroke do
      pdf.line [0.mm,273.mm],[176.mm,273.mm]
    end
  end
end



def header_contents(project, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.role' => "owner", 'projectusers.project_id' => project.id).first

#font styles for page  
  header_style = {:size => 9}
#formating for lines  
  header_format = header_style.merge(:align => :left)

  pdf.y = pdf.bounds.top

  if settings.header_client.show?
    pdf.spec_box "#{project.client}", header_format.merge(:at =>[0.mm, pdf.y])
  end 

  if settings.header_project.show?
    pdf.spec_box "#{project.title}", header_format.merge(:at =>[0.mm, pdf.y])
  end    
    
  if settings.header_document.show?
    pdf.spec_box "Architectural Specification", header_format.merge(:at =>[0.mm, pdf.y])
  end    


  if !settings.header_logo.none?
  
    case settings.header_logo
      when "author" ; url = company.photo.url.sub!(/\?.+\Z/, '') 
      when "company" ; url = client.photo.url.sub!(/\?.+\Z/, '')
    end
  
    pdf.image "#{Rails.root}/public#{url}", :position => :right, :vposition => -11.mm, :align => :right, :fit => [250,25]
  end 
      
end

end
