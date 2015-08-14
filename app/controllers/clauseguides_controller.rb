class ClauseguidesController < ApplicationController

  before_action :set_project, only: [:index, :clone, :clone_clause_list, :assign]

  def index
      #establish project clauses, subsections & sections    
      if @project.CAWS?

        #list of all subsections that can be selected
        @subsections = Cawssubsection.project_subsections(@project)

        if params[:subsection].blank?
          @selected_subsection = Cawssubsection.where(:id => @subsections.ids).first
        else
          @selected_subsection = Cawssubsection.find(params[:subsection])
        end

        #get list of clausetypes in selected subsection
        project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).uniq.ids

        @clauses = Clause.joins(:clauseref => [:subsection]
                        ).where('subsections.cawssubsection_id' => @selected_subsection.id, :id => project_clauses
                        ).order('clauserefs.clause_no, clauserefs.subclause')
      else
        ###uniclass code to go here - same as above
      end
    end


    def new
      @clauseguide = Clauseguide.new
      guidenote = @clauseguide.build_guidenote

      @clause_id = params[:clause_id]
      @plan_id = params[:plan_id]

    end

    # GET /clauseguides/1/edit
    def edit
      authorize @clauseguide
    end

    # POST /pages
    def create
      @clauseguide = Clauseguide.new(clauseguide_params)
      authorize @clauseguide

      if @clauseguide.save
          redirect_to clauseguides_path, notice: 'Expense was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /clauseguides/1
    def update
      authorize @clauseguide
      if @clauseguide.update(clauseguide_params)
#on create redirect back to dashbard
        redirect_to clauseguides_path, notice: 'clauseguide item was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /pages/1
    def destroy
      @clauseguide.destroy
      redirect_to clauseguides_url, notice: 'clauseguide item was successfully destroyed.'
    end


    def clone
      if @project.CAWS?
        @clone_subsections = Cawssubsection.joins(:cawssection, :subsections => [:clauserefs => [:clauses => :speclines]]
                                          ).where('speclines.project_id' => @project.id
                                          ).group('cawssubsections.id'
                                          ).order('cawssections.ref, ref'
                                          )
      else
###uniclass code to go here - same as above
      end#
      @clause_id = params[:id]
      @plan_id = params[:plan_id]
      @clauseguide = Clauseguide.new
    end

    def clone_clause_list
        if @project.CAWS?
          project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).uniq.ids
  
          @clauses = Clause.joins(:clauseguides, :clauseref => [:subsection]
                          ).where('subsections.cawssubsection_id' => params[:id], :id => project_clauses, 'clauseguides.plan_id' => params[:plan_id]
                          ).order('clauserefs.clause_no, clauserefs.subclause')
        else
  ###uniclass code to go here - same as above
        end
    end

    def create_clone
      @clauseguide = Clauseguide.new(clauseguide_params)
      authorize @clauseguide

      if @clauseguide.save
          redirect_to clauseguides_path, notice: 'Expense was successfully created.'
      else
        render :new
      end
    end


    def assign
      @clauseguide_id = params[:id]

      if params[:search_text]
        @search_term = params[:search_text]
      else
        clauseguide = Clauseguide.find(params[:id])
        
        clausetitle = Clausetitle.joins(:clauses).where('clauses.id' => clauseguide.clause_id).first
        @search_term = clausetitle.text
      end

      clausetitles = Clausetitle.where('clausetitles.text LIKE ?', "%#{@search_term}%" ).collect{|i| i.id}.uniq
      project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).collect{|i| i.id}.uniq

        @clauses = Clause.joins(:clausetitle, :speclines, :clauseref => [:subsection]
                    ).where(:clausetitle_id => clausetitles, :id => project_clauses
                    ).group(:id).order('subsections.cawssubsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause')

    end


    def assign_guides

      clauseguide_id = params[:id]
      clauses = Clause.where(:id => params[:clauses])

      clauses.each do |clause|
        clauseguide = Clauseguide.create(:clause_id => clause.id, :guidenote_id => params[:id], :level => params[:plan_id])
      end

      redirect_to clauseguides_path
    end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(13)
    end

    # Only allow a trusted parameter "white list" through.
    def clauseguide_params
      params.require(:clauseguide).permit({:guidenote_attributes => [:text]}, :id, :clause_id, :guidenote_id, :level)
    end
end
