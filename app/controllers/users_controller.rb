class UsersController < ApplicationController
  before_filter :authenticate, only: [:edit, :update]
  before_filter :authenticate_owner, only: [:index, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :unlock_user]
  before_action :set_users, only: [:index, :update_licence_status]
  before_action :set_active_users, only: [:index, :update_licence_status]

  layout "users"

  # GET /users
  # GET /users.json
  def index        
    #company licence management
    #create new User object for form
    @user = User.new 
  end

  def create 

    @user = User.new(user_params)  

    if @user.save
      respond_to do |format| 
        format.html { render :action => "index"}
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end 
    end  
  end

  
  def edit
  end
  

  def update         
    if User.authenticate(current_user.email, params[:user][:password]) == @user
      @user.update(user_params)
    end    
    #logout, as session no longer valid for new password
    redirect_to log_out_path
  end


  #ajax event  
  def update_status
      
    if @user.locked_at == true
      @user.locked_at = false
    end

    @available_licences = @user.company.no_licence - @active_users.count
     
    if @user.active == true
      @user.active = false                     
      @available_licences = @available_licences + 1 
    else      
      if @available_licences >= 0        
        @user.active = true         
        @available_licences = @available_licences - 1          
      end
    end   
    @user.save

    #create new User object for form
    @user = User.new 
    
    respond_to do |format|
        format.js   { render :update_status, :layout => false }
    end 
  end


  #ajax event
  def unlock_user
    @user.update(:failed_attempts => 0, :locked_at => 0)
    respond_to do |format|
        format.js   { render :unlock_user, :layout => false }
    end    
  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(:id => current_user.id).first
    end

    def set_users
      @users = User.where(:company_id => current_user.company_id)
    end
    
    def set_active_users
      @active_users = User.where(:company_id => current_user.company_id, :active => true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:company_id, :first_name, :surname, :email, :role, :api_key, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at, :failed_attempts, :locked_at, :number_times_logged_in, :active, :last_sign_in, :ip)
    end
end
