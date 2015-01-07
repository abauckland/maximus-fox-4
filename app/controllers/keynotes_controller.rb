class KeynotesController < ApplicationController
#  before_filter :authenticate
  before_action :set_project, only: [:show, :keynote_export]
  before_action :set_revision, only: [:show]

  layout "projects"

  def show
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)
    
  end


  def keynote_export    
      if params[:cad_product] == 'csv'
        csv_keynote(@project)
      end 

      if params[:cad_product] == 'revit'
        revit_keynote(@project)
      end 

      if params[:cad_product] == 'bentley'
        bentley_keynote(@project)      
      end 

      if params[:cad_product] == 'cadimage'
        cadimage_keynote(@project)      
      end              
  end

  
  def csv_keynote(project)
  
    #set up for columns, unique identifier column to be set to 'Create Unique IDS'    
    headers = ['ref', 'title', 'ref & title']

    @csv_keynote = CSV.generate do |csv|

      csv << headers
      
      set_subsections(project)
      @subsections.each_with_index do |subsection, n|
        #project subsection
        csv << [subsection.full_code, subsection.text]

        #for each clause
        set_clauses(project, subsection)
        @clauses.each_with_index do |clause, m|
          #project clauses
          csv << [clause.caws_code, clause.clausetitle.text, clause.caws_full_title]
        end
      end
    end

    filename = "#{@project.code}_clause_schedule.csv"

    send_data @csv_keynote, filename: filename, :type => 'text/csv'
  end


  def revit_keynote(project)

    section = Cawssection.first

    data = ""

    project = Project.where(:id => params[:id]).first 

      set_sections(project)
      @sections.each_with_index do |s, i|
        #project section    
        data = data + "#{s.ref}\t#{s.text}\n"       
        #for each subsection
        set_section_subsections(project, s)
        @subsections.each_with_index do |subsection, n|

          #project subsection s
          data = data + "#{sprintf("%02d", subsection.ref).to_s}\t#{subsection.text}\t#{subsection.cawssection.ref}\n"
          
          set_clauses(project, subsection)
          @clauses.each_with_index do |clause, m|
            #project clauses
            data = data + "#{clause.caws_code}\t#{clause.clausetitle.text}\t#{clause.clauseref.subsection.cawssubsection.full_code}\n"
          end 
        end 
      end
     send_data( data, :filename => "#{project.title}_revit_keyontes.txt" ) 
  end
          
  
#  def revit_keynote_export(project_id)
    
#    @current_project = Project.where(:id => params[:id]).first 
    ##!!!!!!need to sort out how it renders - i.e. file dounloads and how to file with correct name and extension  
#    filename = @current_project.code + " specright_keynote"   
#    @bim_revit_export = CSV.generate(:col_sep => "\t") do |csv|   
   
      #for each section 
#      current_project_sections = Section.joins(:subsections => [:clauserefs => [:clauses => :speclines]]).where('speclines.project_id' => @current_project.id).order('id').uniq        
#      current_project_sections.each_with_index do |section, i|
        #project section    
#        csv << [section.ref, section.text]
        #for each subsection     
#        current_project_subsections = Subsection.joins(:clauserefs => [:clauses => :speclines]).includes(:section).where('speclines.project_id' => @current_project.id, :section_id => section.id).order('id').uniq         
#        current_project_subsections.each_with_index do |subsection, n|
          #project subsection
#          csv << [subsection.subsection_code, subsection.text, subsection.section.ref] 
          #for each clause
#          current_project_clauses = Clause.joins(:speclines).includes(:clausetitle, :clauseref => [:subsection => :section]).where('speclines.project_id' => @current_project.id, 'clauserefs.subsection_id' => subsection.id, 'clauserefs.clausetype_id' => [2..4]).order('clauserefs.subsection_id, clauserefs.clausetype_id, clauserefs.clause, clauserefs.subclause').uniq        
#          current_project_clauses.each_with_index do |clause, m|
            #project clauses 
#            csv << [clause.clause_code, clause.clausetitle.text, clause.clauseref.subsection.subsection_code] 
#          end  
#        end 
#      end
#    end  
#    send_data @bim_revit_export, :type => 'text/plain', :disposition => 'attachment; filename=#{filename}.txt'      
#  end


#  def bentley_keynote(project)
    
#    filename = project.code + " specright_keynote"   
#    @bim_bentley_export = CSV.generate do |csv|  
      
      #for each section
#      sections = Cawssection.project_sections(project)
#      sections.each_with_index do |section, i|
        #project section
#        csv << [section.ref << ' ' << section.text]
        
        #for each subsection
#        subsections = Cawssubsection.section_subsections(project, section) 
#        subsections.each_with_index do |subsection, n|
          #project subsection
#          csv << [subsection.full_code << '*' << subsection.text]
          
          #for each clause
#          clauses = Clause.subsection_clauses(project, subsection) 
#          clauses.each_with_index do |clause, m|          
            #project clauses
#            csv << [clause.caws_code << '*' << clause.clausetitle.text]
#          end  
#        end
#        csv << []        
#      end
#    end  
#    send_data @bim_bentley_export, :type => 'text/plain', :disposition => 'attachment; filename=#{filename}.spc'      
#  end


  
  def cadimage_keynote(project)
  
    #set up for columns, unique identifier column to be set to 'Create Unique IDS'    
    headers = ['category', 'ignore', 'Keynote Key', 'Short Description', 'Long Description', 'Specfication Ref.', 'Time Stamp']

    @cadimage_keynote = CSV.generate do |csv|

      csv << headers

      set_subsections(project)
      @subsections.each_with_index do |subsection, n|
        #project subsection
        csv << [subsection.full_code, '', subsection.full_code, subsection.text]

        #for each clause
        set_clauses(project, subsection)
        @clauses.each_with_index do |clause, m|
          #project clauses
          csv << [subsection.full_code, '', clause.caws_code, clause.clausetitle.text]
        end
      end
    end

    filename = "#{@project.code}_cadimage_keynote.csv"

    send_data @cadimage_keynote, filename: filename, :type => 'text/csv'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_sections(project)
      if project.CAWS?
        @sections = Cawssection.project_sections(project)
      else
        ##
      end
    end

    def set_subsections(project)
      if project.CAWS?
        @subsections = Cawssubsection.project_subsections(project)
      else
        ##
      end
    end

    def set_section_subsections(project, section)
      if project.CAWS?
        @subsections = Cawssubsection.section_subsections(project, section)
      else
        ##
      end
    end

    def set_clauses(project, subsection)
      if project.CAWS?
        @clauses = Clause.subsection_clauses(project, subsection)
      else
        ##
      end
    end

    def set_revision
      if params[:revision_id].blank?
        @revision = Revision.where(:project_id => params[:id]).order('created_at').last 
      else
        @revision = Revision.find(params[:revision_id])
      end
    end    
end