class RegistrationsController < Devise::RegistrationsController

  before_filter :check_permissions, :only => [:new, :create]
  skip_before_filter :require_no_authentication
 
  def check_permissions
    #pundit text in here
  end



  # GET /resource/sign_up
  def new
    build_resource({})
    self.resource.build_company
    respond_with self.resource
  end
  
  def new_employee
    build_resource({})
    self.resource.build_company
    respond_with self.resource
  end  

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      #yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
       # sign_up(resource_name, resource)
        if resource.owner?
          respond_with current_user, location: projects_path
        else
          respond_with current_user, location: projects_path
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super # no customization, simply call the devise implementation 
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    super # no customization, simply call the devise implementation 
  end

  # DELETE /resource
  def destroy
    super # no customization, simply call the devise implementation 
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super # no customization, simply call the devise implementation 
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path
    #admins_path
    signed_in_root_path(resource)
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", force: true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    #devise_parameter_sanitizer.for(:user) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :surname, company: [:name]) }
    devise_parameter_sanitizer.sanitize(:sign_up) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :role, :company_id, :check_field, :company_attributes => [:name, :read_term]) }
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :role) }
  end
  
  
end
