module Printfooter

def footer(project, revision, settings, pdf)  
  
  pdf.line_width(0.1)

  pdf.repeat :omit_first_page do
      
    footer_contents(project, settings, pdf)
        
    pdf.stroke do
      pdf.line [0.mm,9.mm],[176.mm,9.mm]
    end
  end
end


def footer_contents(project, revision, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.role' => "owner", 'projectusers.project_id' => project.id).first

  date = selected_revision.created_at
  reformated_date = date.strftime("#{date.day.ordinalize} %b %Y")

  if revisions.rev.nil?
    current_revision_rev = 'n/a'
  else
    current_revision_rev = revision.rev.capitalize    
  end


#font styles for page  
  footer_style = {:size => 8}
#formating for lines  
  footer_format = footer_style.merge(:align => :left)

  if printsetting.footer_author == "show" 
    pdf.spec_box "#{company.name}" , footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 11.mm])
  end 

  if printsetting.footer_detail == "show" 
    pdf.spec_box "Project Ref: #{project.code} Status: #{project.project_status} Rev: #{current_revision_rev}", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 7.mm])
  end 

  if printsetting.footer_date == "show" 
    pdf.text_box "Created: #{reformated_date}", footer_format.merge(:at =>[0.mm, pdf.bounds.bottom + 3.mm])
  end    
     
end

end