class UsersController < ApplicationController

  before_action :set_user, only: [:show, :activate, :deactivate]

  layout "users"

  def index
    #company licence management
    #create new User object for form
    @user = User.new 
  end

  def show
    #if current_user.company_id == @user.company_id
    authorize @user   
  end

  def activate
    authorize @user
    if @user.activate!
      respond_to do |format|
        format.js   { render :activate, :layout => false }
      end 
    end 
  end

  def deactivate
    authorize @user
    if @user.deactivate!
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
