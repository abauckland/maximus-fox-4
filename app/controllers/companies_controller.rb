class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  layout "websites", :except => [:edit]
  layout 'users', :except => [:new]


  # GET /companies/new
  def new
    @company = Company.new
    authorize @company
    user = @company.users.build
  end

  # GET /companies/1/edit
  def edit
    authorize @company
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    authorize @company
    
    respond_to do |format|
      if @company.save
                
        user = User.where('company_id =?', @company.id).first    
        session[:user_id] = user.id

        create_demo_project        
        create_project_user(@project, user)    
        set_current_revision(@project, user)  

        
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    authorize @company
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to :edit, notice: 'Company was successfully updated.' }
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
      params.require(:company).permit(:name, :tel, :www, :reg_address, :reg_number, :reg_name, :reg_location, :read_term, :category, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :no_licence)
    end

    
    def create_demo_project    
        #create demonstration project
        @project = Project.create(:code => 'D1', :title => 'Demo Project', :parent_id => 2, :project_status => 'Draft', :rev_method => 'Project')
    end
    
    def create_project_user(project, user)
        #set project_user for project
        Projectuser.create(:project_id => @project.id, :user_id => user.id)       
    end
    
    def set_current_revision(project, user)        
        #set current revision reference for demo project
        Revision.create(:project_id => @project.id, :user_id => user.id, :date => Date.today)
    end
    
end
