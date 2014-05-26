class PrintsettingsController < ApplicationController
  before_filter :authenticate
  before_action :set_project, only: [:edit, :update]
  before_action :set_printsetting, only: [:edit, :update]
  before_filter :authorise_project_manager, only: [:edit]
    
  # GET /projects/1/edit
  def edit

  end
    

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    respond_to do |format|
      if @printsetting.update(printsetting_params)
        format.html { redirect_to :edit, notice: 'Print Settings were successfully updated.' }
        format.json { render :show, status: :ok, location: @printsetting }
      else
        format.html { render :edit }
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
      @printsetting = Printsetting.find(:project_id => params[:id]).last
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:printsetting).permit(:font_style, :font_size, :structure, :prelim, :page_number, :client_detail, :client_logo, :project_detail, :project_image, :company_detail, :header_project, :header_client, :header_document, :header_logo, :footer_detail, :footer_author, :footer_date)
    end

    def authorise_project_manager
      project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id], :role => "manage").first    
      if project_user.blank?
        redirect_to log_out_path
      end 
    end


end


