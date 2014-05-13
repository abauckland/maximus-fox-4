class AlterationsController < ApplicationController
  before_action :set_change, only: [:print_setting]


  def clause_change_info
      @clause_change_info = Alteration.select('user.email, created_at').includes(:user).where('project_id = ? AND clause_id = ? AND revision_id =?', params[:id], params[:clause_id], params[:rev_id]).last
      @clause_id = params[:clause_id]
      respond_to do |format|
        format.js   { render :clause_change_info, :layout => false }
      end
  end

  def line_change_info
      @line_change_info = Alteration.select('user.email, created_at').includes(:user).where(:id => params[:id]).first
      @line_id = params[:id]
      
      respond_to do |format|
        format.js   { render :line_change_info, :layout => false }
      end
  end

  def print_setting
    if @change.print_change == false
      @change.print_change = true
      @current_rev_line_class = '_strike'
      @next_rev_line_class = ''
      @rev_print_image = 'noprint_rev.png' 
    else
      @change.print_change = false
      @current_rev_line_class = ''
      @next_rev_line_class = '_strike'
      @rev_print_image = 'print_rev.png'
    end
    @change.save
        
    respond_to do |format|
      format.js   { render :layout => false }
    end    
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_change
      @change = Alteration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def change_params
      params.require(:alteration).permit(:specline_id, :project_id, :clause_id, :txt1_id, :txt2_id, :txt3_id, :txt4_id, :txt5_id, :txt6_id, :identity_id, :perform_id, :linetype_id, :event, :clause_add_delete, :revision_id, :print_change, :user_id)
    end
end
