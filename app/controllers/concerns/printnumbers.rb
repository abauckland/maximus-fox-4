module Printnumbers

def page_numbers(document_page_start, document_page_end, settings, pdf)
  
    if settings.page_number == "by document"
        document_page_numbers(document_page_start, document_page_end, pdf)
    else
        #section_page_numbers(subsection_pages, pdf)
    end
end  


def document_page_numbers(document_page_start, document_page_end, pdf) 
  
  total_pages = (document_page_end - document_page_start)+1
  
  pdf.repeat(document_page_start..document_page_end, :dynamic => true) do          
    pdf_page_number = (pdf.page_number - document_page_start)+1
    page_number(pdf_page_number, total_pages, pdf)            
  end  
end


def page_number(current_page, total_pages, pdf)
  page_number_style = {:size => 8, :align => :right}
  
  #pdf.text_box "#{subsection.full_code_and_title}", page_number_style.merge(:at => [100.mm,7.mm])
  pdf.text_box "Page #{current_page} of #{total_pages}", page_number_style.merge(:at => [150.mm,6.mm])
end



def section_page_numbers(subsection_pages, pdf)
 
    #for each section apply page numbers
    #carries out action for each section in tern

    #recorded start of each section in main print template
    #[["M40", 10], ["M52", 15], ["M60", 20]]
    subsection_pages.each_with_index do |page, i| 

        start_page = page[:number]
        finish_page = subsection_pages[i+1][:number]

        #number of pages in each subsection
        #add 1 - otherwise would be range starting at page '0' 
        total_pages = (finish_page-start_page)+1   

        #go through whole document and apply numbers for section on correct pages
        pdf.repeat(:all, :dynamic => true) do          
           
            pdf_page_number = pdf.page_number
            if pdf_page_number.between?(start_page,finish_page)
                #establish current section page number            
                current_page = (pdf.page_number-start_page)+1
                #print page numbers and text
                page_number_range(page[:subsection], current_page, total_pages, pdf)
            end          
        end
    end 
end

  



def page_number_range(subsection, current_page, total_pages, pdf)
  page_number_style = {:size => 8, :align => :right}

  pdf.text_box "#{subsection.full_code_and_title}", page_number_style.merge(:at => [100.mm,7.mm])
  pdf.text_box "Page #{current_page} of #{total_pages}", page_number_style.merge(:at => [150.mm,3.mm])
end

end