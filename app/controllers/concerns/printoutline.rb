module Printoutline

  def outline(subsection_pages, pdf)

    outline.define do
      subsection_pages.each do |page|
        section(page[:subsection], :destination => page[:number])
      end
    end

  end

end