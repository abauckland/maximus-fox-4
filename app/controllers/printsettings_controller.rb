class PrintsettingsController < ApplicationController

  before_action :set_project, only: [:edit]
  before_action :set_printsetting, only: [:edit]
  before_action :set_project_update, only: [:update]
  before_action :set_variables, only: [:edit]

  include ProjectuserDetails

  layout "projects"

  # GET /projects/1/edit
#TODO make prinsetting child of project so can identify by printsetting id - printsetting has has_one project
  def edit
    authorize :printsetting, :edit?
  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    @printsetting = Printsetting.find(params[:id])
    authorize :printsetting, :update?

    respond_to do |format|
      if @printsetting.update(printsetting_params)
        format.html { redirect_to edit_printsetting_path(@printsetting.project_id), notice: 'Print Settings were successfully updated.' }
      else
        format.html { render edit_printsetting_path(@printsetting.project_id) }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_project_update
      @printsetting = Printsetting.find(params[:id])
      @project = Project.find(@printsetting.project_id)
    end

    def set_printsetting
      @printsetting = Printsetting.where(:project_id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def printsetting_params
      params.require(:printsetting).permit(:font_style, :font_size, :structure, :prelim, :page_number, :client_detail, :client_logo, :project_detail, :project_image, :company_detail, :header_project, :header_client, :header_document, :header_logo, :footer_detail, :footer_author, :footer_date)
    end

    def set_variables

      @font_styles = ["Times-Roman", "Helvetica"]
      @font_sizes = ["small", "medium", "large"]
  
      @structures = ["revisions by document", "revision by section"]
      @prelims = ["single section", "separate sections"]
      @page_numbers = ["by section", "by document"]
  
      @section_covers = ["section cover", "no cover"]
  
    #docuemnt cover
      @client_details = ["none", "left", "center", "right"]
      @client_logos = ["none", "left", "center", "right"]
      @project_details = ["none", "left", "center", "right"]
      @project_images = ["none", "left", "center", "right"]
      @company_details = ["none", "left", "center", "right"]
   
    #header settings
      @header_projects = ["none", "show"]
      @header_clients = ["none", "show"]
      @header_documents = ["none", "show"]
      @header_logos = ["none", "author", "client"]
  
    #footer settings
      @footer_details = ["none", "show"]
      @footer_authors = ["none", "show"]
      @footer_dates = ["none", "show"]

    end

end