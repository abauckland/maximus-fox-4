module Printfooter

def footer(project, revision, settings, header_page_start, header_page_end, pdf)  
  
  pdf.line_width(0.1)

  pdf.repeat(header_page_start..header_page_end) do
 
    footer_contents(project, revision, settings, pdf)
        
    pdf.stroke do
      pdf.line [0.mm,12.mm],[176.mm,12.mm]
    end
  end
end


def footer_contents(project, revision, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.project_id' => project.id).first

  date = revision.created_at
  reformated_date = date.strftime("#{date.day.ordinalize} %b %Y")

  if revision.rev.nil?
    current_revision_rev = 'n/a'
  else
    current_revision_rev = revision.rev.capitalize    
  end


#font styles for page  
  footer_style = {:size => 8}
#formating for lines  
  footer_format = footer_style.merge(:align => :left)

  if settings.footer_author == "show" 
    pdf.spec_box "#{company.name}" , footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 10.mm])
  end 

  if settings.footer_detail == "show" 
    pdf.spec_box "Project Ref: #{project.code}, Status: #{project.project_status}, Rev: #{current_revision_rev}", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 7.mm])
  end 

  if settings.footer_date == "show" 
    pdf.text_box "Created: #{reformated_date}", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 4.mm])
  end    
     
end

end