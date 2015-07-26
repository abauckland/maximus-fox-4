
  class DatasController < ApplicationController

    before_action :set_project, only: [:show, :download]
    before_action :set_revision, only: [:show, :download]

    layout "projects", :except => [:download]

    def show
    end

    def download
      if params[:product_data] == 'products_accessories'

        case @revision.rev
        when nil ; filename = "Product_data_#{@project.code}_rev_na.csv"
        when '-'; filename = "Product_data_#{@project.code}_rev_-.csv"
        else
          filename = "Product_data_#{@project.code}_rev_#{@revision.rev.upcase}.csv"
        end

        send_data product_data_csv(@project), filename: filename, :type => "text/csv"
      end
    end


    private
    def set_project
      @project = Project.find(params[:id])
    end

    def set_revision
      @revision = Revision.where(:project_id => params[:id]).last

    end

    def product_data_csv(project)

#list of clauses with product data
      clauses = Clause.joins(:clauseref, :speclines
                     ).where('speclines.project_id' => project.id, 'clauserefs.clausetype_id' => [4,5], 'speclines.linetype_id' => 8
                     ).where.not('speclines.txt4id' => 1, 'speclines.txt5_id' => 1
                     ).uniq

      product_date = CSV.generate do |csv|

        csv << csv_product_header_array(project)

        clauses.each do |clause|

          if @project.CAWS?
            clause_ref = clause.caws_code
          else
            ##uniclass code
          end
          @clause_info = [clause_ref, clause.clausetitle.text]

          @sorted_header_array.each_with_index do |header, i|

            @product_info = []
            attribute_value = Txt5.joins(:speclines => [:txt4, :clause => [:clauseref]]
                                 ).where('speclines.project_id' => params[:project_id], 'txt4s.text' => header, 'clauserefs.clausetype_id' => [4,5]
                                 ).where.not(:id => 1
                                 ).first

            if attribute_value != nil
              @product_info[i] = attribute_value.text
            end

          end
            if @product_info.length > 0
              @clause_info + @product_info
            end
        end
          csv << @clause_info
      end
    end

    def csv_product_header_array(project)
      fixed_headers = ["clause reference","clause title"]
      attibrute_headers(project)
      header_row = fixed_headers + @sorted_header_array
    end

    def attibrute_headers(project)
      header_hash = Txt4.joins(:speclines => [:clause => :clauseref]
                       ).where('speclines.project_id' => project.id, 'clauserefs.clausetype_id' => [4,5], 'speclines.linetype_id' => 8
                       ).where.not(:id => 1, 'speclines.txt5_id' => 1
                       ).group(:text).count
 
      headers_ordered = header_hash.sort_by{|key, value| value}
      @sorted_header_array = headers_ordered.collect(&:first)
      @sorted_header_array.reverse!
    end

  end

