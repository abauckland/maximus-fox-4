
  class DatasController < ApplicationController

    before_action :set_project, only: [:show, :download]
    before_action :set_revision, only: [:show, :print_project]

    layout "projects", :except => [:download]

    def show
    end

    def download
      if params[:product_data] == 'products_accessories'
        filename = "Product_data_#{@project.code}_rev_#{@revision.rev.upcase}.csv"
        send_data product_data_csv(@project), filename: filename, :type => "text/csv"
      end
    end


    private
    def set_project
      @project = Project.find(params[:id])
    end

    def set_revision
      @revision = Revision.find(params[:revision_id])

    end

    def product_data_csv(project)

      clauses = Clause.joins(:clauserefs, :speclines
                     ).where( 'speclines.project_id' => project.id, 'clauserefs.clausetype_id' => [4,5]).where.not('speclines.txt4_id' => 1
                     ).uniq

      product_date = CSV.generate do |csv|

        csv << csv_product_header_array(project)

        clauses.each do |clause|

          clause_info = [clause.ref, clause.clausetitle]

          sorted_header_array.each_with_index do |header, i|

            product_info = []
            attribute_value = Txt4.joins(:specline => [:txt3s, :clause => [:clauseref]]
                                 ).where('speclines.project_id' => params[:project_id], 'txt3s.text' => header, 'clauserefs.clausetype_id' => [4,5]
                                 ).where.not(:id => 1
                                 ).first

            product_info[i] = attribute_value.text csv << clause_info

          end
          clause_info << product_info
        end

        csv << clause_info
      end
    end

    def csv_product_header_array(project)
      fixed_headers = ["clause reference","clause title"]
      attibrute_headers(project)
      header_row = fixed_headers << sorted_header_array
    end

    def attibrute_headers(project)
      header_hash = Txt3.joins(:specline => [:clause => :clauseref]
                       ).where('speclines.project_id' => project.id, 'clauserefs.clausetype_id' => [4,5]
                       ).where.not('speclines.txt4_id' => 1
                       ).group(:text).count

      headers_ordered = header_hash.sort_by{|key, value| value}
      sorted_header_array = headers_ordered .collect(&:first)
    end

  end
