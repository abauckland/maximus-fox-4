class CompaniesController < ApplicationController
  before_filter :authenticate_owner, only: [:edit, :update]
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  layout "users", only: [:edit]

  # GET /companies/new
  def new
    @company = Company.new
    user = @company.users.build
    respond_to do |format|
      format.html { render layout: "websites" }
    end

  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    
    respond_to do |format|
      if @company.save
                
        user = User.where(:company_id => @company.id).first
        user.update(:role => "owner", :active => true)    
        session[:user_id] = user.id

        create_demo_project        
        create_project_user(@project, user)    
        set_current_revision(@project, user)  

        
        format.html { redirect_to projects_path }
      else
        format.html { render :new,  layout: "websites" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update

    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to edit_company_path(@company), notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit({:users_attributes => [:first_name, :surname, :email, :role, :active, :password, :password_confirmation]}, :check_field, :name, :tel, :www, :reg_address, :reg_number, :reg_name, :reg_location, :read_term, :category, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :no_licence)
    end

    
    def create_demo_project    
        #create demonstration project
        @project = Project.create(:code => 'D1', :title => 'Demo Project', :parent_id => 1, :project_status => 'Draft', :ref_system => 'caws')
        project_template = Project.where(:id => [1..10], :ref_system => @project.ref_system).first
        @project.update(:parent_id => project_template.id)
    end
    
    def create_project_user(project, user)
        #set project_user for project
        Projectuser.create(:project_id => project.id, :user_id => user.id, :role => "manage") 
        Printsetting.create(:project_id => project.id)      
    end
    
    def set_current_revision(project, user)        
        #set current revision reference for demo project
        Revision.create(:project_id => project.id, :user_id => user.id, :date => Date.today)
    end
    
end
