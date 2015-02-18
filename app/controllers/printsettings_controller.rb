class PrintsettingsController < ApplicationController
#  before_filter :authenticate
  before_action :set_project, only: [:edit]
  before_action :set_printsetting, only: [:edit]
  before_filter :authorise_project_manager, only: [:edit]

  layout "projects"
    
  # GET /projects/1/edit
  def edit

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
    

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    @printsetting = Printsetting.find(params[:id])
    respond_to do |format|
      if @printsetting.update(printsetting_params)
        format.html { redirect_to edit_printsetting_path(@printsetting.project_id), notice: 'Print Settings were successfully updated.' }
        format.json { render :show, status: :ok, location: @printsetting }
      else
        format.html { render edit_printsetting_path(@printsetting.project_id) }
        format.json { render json: @printsetting.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_printsetting
      @printsetting = Printsetting.where(:project_id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def printsetting_params
      params.require(:printsetting).permit(:font_style, :font_size, :structure, :prelim, :page_number, :client_detail, :client_logo, :project_detail, :project_image, :company_detail, :header_project, :header_client, :header_document, :header_logo, :footer_detail, :footer_author, :footer_date)
    end

    def authorise_project_manager
      project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id], :role => "manage").first
      if project_user.blank?
        redirect_to log_out_path
      end 
    end


end


