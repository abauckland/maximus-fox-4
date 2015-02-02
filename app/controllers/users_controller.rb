class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  layout "users"

  def index
    #company licence management
    #create new User object for form
    @users = User.where(:company_id => current_user.company_id) 

    @licences_used = User.where(:company_id => current_user.company_id, :state => "active").count
    @licences_total = Company.joins(:users).where('users.company_id' => current_user.company_id).pluck(:no_licence).first
  end

  def show
    #if current_user.company_id == @user.company_id
#    authorize @user
  end

  def activate
    @user = User.where(:id => params[:id]).first

    no_licences = Company.where(:id => current_user.company_id).pluck(:no_licence).first
    active_licences = User.where(:company_id => current_user.company_id, :state => "active").length

    if no_licences == active_licences
      respond_to do |format|
        format.js   { render :insufficient_licences, :layout => false }
      end
    else
#    authorize @user
      @user.activate!
      @licences_used = User.where(:company_id => current_user.company_id, :state => "active").count
      @licences_total = Company.joins(:users).where('users.company_id' => current_user.company_id).pluck(:no_licence).first
      respond_to do |format|
        format.js   { render :activate, :layout => false }
      end 
    end 
  end

  def deactivate

    @user = User.where(:id => params[:id]).first
#    authorize @user
    if @user.deactivate!
      @licences_used = User.where(:company_id => current_user.company_id, :state => "active").count
      @licences_total = Company.joins(:users).where('users.company_id' => current_user.company_id).pluck(:no_licence).first
      respond_to do |format|
        format.js   { render :deactivate, :layout => false }
      end 
    end 
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(:id => current_user.id).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :surname)
    end
end
