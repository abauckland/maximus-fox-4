class UsersController < ApplicationController
#  before_filter :authenticate, only: [:edit, :update]
#  before_filter :authenticate_owner, only: [:index, :create]
  before_action :set_user, only: [:show, :edit, :update, :unlock_user]
  before_action :set_users, only: [:index, :update_licence_status]
  before_action :set_active_users, only: [:index, :update_status, :update_licence_status]

  layout "users"

  # GET /users
  # GET /users.json
  def index        
    #company licence management
    #create new User object for form
    @user = User.new 
  end

#  def create #

#    @user = User.new(user_params)  

#    if @user.save
      
#        projects =  Project.where(:company_id => current_user.company_id)
#        projects.each do |project|
#          Projectuser.create(:project_id => project.id, :user_id => @user.id, :role => "manage")
#        end
      
      
#      respond_to do |format| 
#        format.html { render :action => "index"}
#      end
#    else
#       respond_to do |format| 
#        format.html { render :action => "index"}
#        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity } 
#        end      
#    end  
#  end

  
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
      
    @selected_user = User.where(:id => params[:id]).first  
      
    if @selected_user.locked_at == 1
      @selected_user.locked_at = 0
    end

    @available_licences = current_user.company.no_licence - @active_users.count
     
    if @selected_user.active == 1
      @selected_user.active = 0                     
      @available_licences = @available_licences + 1 
    else      
      if @available_licences >= 0        
        @selected_user.active = 1        
        @available_licences = @available_licences - 1          
      end
    end   
    @selected_user.save


    respond_to do |format|
        format.js { render :update_status, :layout => false }
    end 
  end


  #ajax event
#  def unlock_user
#    @user.update(:failed_attempts => 0, :locked_at => 0)
#    respond_to do |format|
#        format.js { render :unlock_user, :layout => false }
#    end    
#  end 


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
      params.require(:user).permit(:company_id, :first_name, :surname, :email, :role, :api_key, :password, :password_confirmation, :failed_attempts, :locked_at, :number_times_logged_in, :active, :last_sign_in, :ip)
    end
end
