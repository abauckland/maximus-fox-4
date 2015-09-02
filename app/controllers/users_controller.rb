class UsersController < ApplicationController

  before_action :set_user, only: [:show, :activate, :deactivate]
  before_action :set_licenses_used, only: [:index, :activate, :deactivate]
  before_action :set_licenses_total, only: [:index, :activate, :deactivate]

  layout "users"


  def index
    @users = policy_scope(User) 
    authorize @users
  end

  def show
    @user = User.where(:id => current_user.id).first
    authorize @user
  end

  def activate
    authorize @user

    if @licences_used == @licences_total
      respond_to do |format|
        format.js   { render :insufficient_licences, :layout => false }
      end
    else
      @user.activate!
      set_licenses_used
      set_licenses_total
      respond_to do |format|
        format.js   { render :activate, :layout => false }
      end
    end
  end


  def deactivate
    authorize @user

    if @user.deactivate!
      set_licenses_used
      set_licenses_total
      respond_to do |format|
        format.js   { render :deactivate, :layout => false }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(:id => params[:id]).first
    end

    def set_licenses_used
      @licences_used = policy_scope(User).where(:state => "active").count
    end

    def set_licenses_total
      @licences_total = Company.joins(:users).where('users.company_id' => current_user.company_id).pluck(:no_licence).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :surname)
    end
end
