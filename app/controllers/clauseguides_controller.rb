class ClauseguidesController < ApplicationController

  before_action :set_clauseguide, only: [:edit, :destroy, :update]
  before_action :set_project, only: [:index, :clone, :clone_clause_list, :assign, :duplicate]
  before_action :set_subsection

  include RefsystemSettings

  layout "administrations"

  def index
    authorize :clauseguides, :index?
        #list of all subsections that can be selected
        @subsections = @subsection_model.project_subsections(@project)

        if params[:subsection_id].blank?
          @selected_subsection = @subsection_model.first
        else
          @selected_subsection = @subsection_model.find(params[:subsection_id])
        end

        #get list of clausetypes in selected subsection
        project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).uniq.ids
        @clauses = Clause.project_clauses(project_clauses, @selected_subsection.id, @subsection_name)

    end

    def show
      @clauseguide = Clauseguide.find(params[:id])
      authorize @clauseguide
    end

    def new
      @clauseguide = Clauseguide.new
      guidenote = @clauseguide.build_guidenote

      @clause_id = params[:clause_id]
      @plan_id = params[:plan_id]

    end

    # GET /clauseguides/1/edit
    def edit
      @clauseguide = Clauseguide.find(params[:id])
      authorize @clauseguide
    end

    # GET /clauseguides/1/edit
    def edit_all
      @clauseguide = Clauseguide.find(params[:id])
      authorize @clauseguide
    end



    # POST /pages
    def create
      @clauseguide = Clauseguide.new(clauseguide_params)
      authorize @clauseguide

      if @clauseguide.save
          redirect_to clauseguides_path(:subsection_id => @subsection_id), notice: 'Expense was successfully created.'
      else
        render :new
      end
    end


    def update
      authorize @clauseguide

      text_exist = Guidenote.where(:text => params[:clauseguide][:guidenote_attributes][:text]).first
      if text_exist.blank?
        guidenote = Guidenote.create(:text => params[:clauseguide][:guidenote_attributes][:text])
      else
        guidenote = text_exist
      end

      if @clauseguide.update(:guidenote_id => guidenote.id)
        redirect_to clauseguides_path(:subsection_id => @subsection_id), notice: 'clauseguide item was successfully updated.'
      else
        redirect_to clauseguides_path(:subsection_id => @subsection_id)
      end
    end


    def update_all
      authorize @clauseguide

      guidenote = Guidenote.find(@clauseguide.guidenote_id)
      guidenote.text = params[:clauseguide][:guidenote_attributes][:text]

      if guidenote.save
        redirect_to clauseguides_path(:subsection_id => @subsection_id), notice: 'clauseguide item was successfully updated.'
      else
        redirect_to clauseguides_path(:subsection_id => @subsection_id)
      end
    end


    # DELETE /pages/1
    def destroy
      @clauseguide = Clauseguide.find(params[:id])
      @clauseguide.destroy
      redirect_to clauseguides_url, notice: 'clauseguide item was successfully destroyed.'
    end


    def clone
      @clone_subsections = @subsection_model.project_subsections(@project)
      @clause_id = params[:id]
      @plan_id = params[:plan_id]
      @clauseguide = Clauseguide.new
    end

    def clone_clause_list

      @clauseguides = Clauseguide.project_guides(@project, params[:id], @subsection_name)

    end

    def create_clone
      @clauseguide = Clauseguide.new(:plan_id => params[:plan_id], :clause_id => params[:clause_id], :guidenote_id => params[:guidenote_id])
#      authorize @clauseguide

      if @clauseguide.save
          redirect_to clauseguides_path(:subsection_id => @subsection_id), notice: 'Expense was successfully created.'
      else
        render :new
      end
    end


    def assign

      @clauseguide = Clauseguide.find(params[:id])

      @plan_id = @clauseguide.plan_id
      @guidenote_id = @clauseguide.guidenote_id

      if params[:search_text]
        @search_term = params[:search_text]
      else   
        clausetitle = Clausetitle.joins(:clauses).where('clauses.id' => @clauseguide.clause_id).first
        @search_term = clausetitle.text
      end

      clausetitles = Clausetitle.where('clausetitles.text LIKE ?', "%#{@search_term}%" ).collect{|i| i.id}.uniq
      project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).collect{|i| i.id}.uniq

      clause_with_guides_ids = Clauseguide.where(:plan_id => @plan_id).collect{|i| i.clause_id}.uniq

        @clauses = Clause.joins(:clausetitle, :speclines, :clauseref => [:subsection]
                    ).where(:clausetitle_id => clausetitles, :id => project_clauses
                    ).where.not(:id => clause_with_guides_ids
                    ).group(:id).order('subsections.cawssubsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause')

    end


    def assign_guides

      clauses = Clause.where(:id => params[:clauses])

      clauses.each do |clause|
        clauseguide = Clauseguide.create(:clause_id => clause.id, :guidenote_id => params[:guidenote_id], :plan_id => params[:plan_id])
      end

      redirect_to clauseguides_path(:subsection_id => @subsection_id)
    end


    def duplicate
      clauseguide = Clauseguide.find(params[:id])

      @plan_id = clauseguide.plan_id
      @guidenote_id = clauseguide.guidenote_id

      subsection_id = clauseguide.clause.clauseref.subsection_id

      project_clauses = Clause.joins(:speclines).where('speclines.project_id' => @project.id).collect{|i| i.id}.uniq

      clause_with_guides_ids = Clauseguide.where(:plan_id => @plan_id).collect{|i| i.clause_id}.uniq

        @clauses = Clause.joins(:speclines, :clauseref => [:subsection]
                    ).where('clauserefs.subsection_id' => subsection_id, :id => project_clauses
                    ).where.not(:id => clause_with_guides_ids
                    ).group(:id).order('subsections.cawssubsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause')


    end

    def duplicate_guides
      clauses = Clause.where(:id => params[:clauses])

      clauses.each do |clause|
        clauseguide = Clauseguide.create(:clause_id => clause.id, :guidenote_id => params[:guidenote_id], :plan_id => params[:plan_id])
      end

      redirect_to clauseguides_path(:subsection_id => @subsection_id)
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clauseguide
      @clauseguide = Clauseguide.find(params[:id])
    end

    def set_project
      @project = Project.find(2)
    end

    def set_subsection
      @subsection_id = params[:subsection_id]
    end

    # Only allow a trusted parameter "white list" through.
    def clauseguide_params
      params.require(:clauseguide).permit({:guidenote_attributes => [:text]}, :id, :clause_id, :guidenote_id, :plan_id)
    end
end

