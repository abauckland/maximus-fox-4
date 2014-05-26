class SessionsController < ApplicationController

layout "mobiles"

  def new
  
      respond_to do |format|  
        format.html 
        format.mobile {render :layout => "mobile"}
      end    
  end
     
  #used by mobile login - session/new
  def create

    if params[:email].blank? || params[:password].blank?
       redirect_to home_path, notice: 'show forgotten password link'      
    else
    
    email_check = User.where('email = ?', params[:email]).first      
    if email_check.blank? 
      redirect_to home_path, notice: 'show forgotten password link'       
    else
      
    @user = User.authenticate(params[:email], params[:password]) 
    if @user  
      session[:user_id] = @user.id  
      
      if @user.locked_at == true
        #redirect to locked page        
        redirect_to(:controller => 'password_resets', :action => 'locked', :id => @user.id)
      else
        if @user.active == false
          #redirect to inactive licence page 
          redirect_to(:controller => 'password_resets', :action => 'deactivated', :id => @user.id)         
        else    
        @user.last_sign_in = Time.now
        @user.number_times_logged_in = @user.number_times_logged_in += 1
        @user.ip = request.remote_ip
        @user.failed_attempts = 0
        @user.save
            
        redirect_to projects_path
        end
      end      
    else
    
      @user = User.where('email=?', params[:email]).first
      @user.failed_attempts = @user.failed_attempts += 1
      if @user.failed_attempts == 3
        #if user.role != 'admin'
          @user.locked_at = true
        #end
      end      
      @user.save 
      redirect_to new_session_path, notice: 'show forgotten password link' 
    end      
  end
  end
  end  
  
  #used by homepage (root) login
  def create_session  

    if params[:email].blank? || params[:password].blank?
       redirect_to home_path, notice: 'show forgotten password link'      
    else
    
    email_check = User.where('email = ?', params[:email]).first      
    if email_check.blank? 
      redirect_to home_path, notice: 'show forgotten password link'       
    else
      
    @user = User.authenticate(params[:email], params[:password]) 
    if @user  
      session[:user_id] = @user.id  
    
      if @user.locked_at == true
        #redirect to locked page        
        redirect_to(:controller => 'password_resets', :action => 'locked', :id => @user.id)
      else
        if @user.active == false
          #redirect to inactive licence page 
          redirect_to(:controller => 'password_resets', :action => 'deactivated', :id => @user.id)         
        else    
        @user.last_sign_in = Time.now
        @user.number_times_logged_in = @licence.number_times_logged_in += 1
        @user.ip = request.remote_ip
        @user.failed_attempts = 0
        @user.save
            
        redirect_to projects_path
        end
      end      
    else
    
      @user = User.where('email=?', params[:email]).first
      @user.failed_attempts = @user.failed_attempts += 1
      if @user.failed_attempts == 3
        #if user.role != 'admin'
          @user.locked_at = true
        #end
      end      
      @user.save 
      redirect_to home_path, notice: 'show forgotten password link' 
    end  
  end

end
end

  
  def destroy  
    session[:user_id] = nil  
    redirect_to home_path 
  end
  
     
end
