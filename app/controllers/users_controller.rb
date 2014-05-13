class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :unlock_user]

  # GET /users
  # GET /users.json
  def index
    @users = policy_scope(User)
    authorize @users
  end

  def create 
    authorize @user
  #  @company = Company.where('id =?', current_user.company_id).first    
  #  @array_user_ids = User.where(:company_id => current_user.company_id).collect{|i| i.id}.sort
  #  @licences = Licence.where(:user_id => @array_user_ids)
  #  @active_licences = Licence.where(:user_id => @array_user_ids, :active_licence => 1)
   # @account = Account.where(:company_id => current_user.company_id).first

    @user = User.new(user_params)  
                 
 #   @permisable_licences = Account.where('company_id =?', current_user.company_id ).first
  #  total_licences_used = User.where('company_id =?', current_user.company_id ).count
               
      if @user.save
      
    #    licence = Licence.new
    #    licence.user_id = @user.id
    #    licence.save
        
#        redirect_to(:controller => "users", :action => "edit", :id => current_user.id)
#      else
      #! not sure this is ever accessed
      respond_to do |format| 
        format.html { render :action => "edit", :id => current_user.id}
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }


      end 
    end  
  end

  #company licence management
  def edit
    #check project ownership private method
    authorize @user      
 #   @company = Company.where('id =?', current_user.company_id).first
    @array_user_ids = User.where(:company_id => current_user.company_id).collect{|i| i.id}.sort
  #  @licences = Licence.where(:user_id => @array_user_ids)
  #  @active_licences = Licence.where(:user_id => @array_user_ids, :active_licence => 1)
  #  @account = Account.where(:company_id => current_user.company_id).first
  #  @available_licences = @account.no_licence - @active_licences.count
  #  @licence = params[:licence]
    
    #create new User object for form
    @user = User.new  
  end
  

  def update
     
    #@current_project = Project.where('id = ? AND company_id =?', params[:id], current_user.company_id).first
    authorize @user
    #if @current_project.blank?
    #  redirect_to log_out_path
    #end
    
    if User.authenticate(current_user.email, params[:user][:password]) == @user

      @user.first_name = params[:user][:first_name]
      @user.surname = params[:user][:surname]
      @user.email = params[:user][:email] 
      if params[:new_password] == params[:new_password_confirmation]  
        @user.password = params[:new_password]    
      end
     @user.save
    end
    #logout, as session no longer valid for new password
    redirect_to log_out_path
  end



  #ajax event  
  def update_licence_status
    authorize @user  

    
    if @user.locked_at != 0
      @user.locked_at = 0
    end

    @users = policy_scope(User)
    @active_users = policy_scope(User).where(:active_licence => true)
             
        
    if @user.active_licence == 1
      @user.active_licence = 0                     
      @available_users = @user.company.no_licence - @active_users.count + 1 
    else      
      if @available_licences >= 0        
        @user.active_licence = 1         
        @available_users = @user.company.no_licence - @active_users.count - 1          
      else
        @available_users = @user.company.no_licence - @active_users.count  
      end
    end
    @user.save

    #create new User object for form
    @user = User.new 
            
    redirect_to(:controller => "users", :action => "edit", :id => current_user.id)

  end


  #ajax event
  def unlock_user
    authorize @user 
    @user.update(:failed_attempts => 0, :locked_at => 0)
    @user.save

    respond_to do |format|
        format.js   { render :unlock_user, :layout => false }
    end  
  
  end 




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:company_id, :first_name, :surname, :email, :role, :api_key, :password_hash, :password_salt, :password_reset_token, :password_reset_sent_at)
    end
end
