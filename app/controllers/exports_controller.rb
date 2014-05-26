class ExportsController < ActionController::Base

before_action :set_project, only: [:keynote_export]


  def keynote_export    
      if params[:cad_product] == 'revit'
        revit_keynote_export(@project)
      end 

      if params[:cad_product] == 'bentley'
        bentley_keynote_export(@project)      
      end 

      if params[:cad_product] == 'cadimage'
        cadimage_keynote_export(@project)      
      end              
  end
  

#File.open('file.txt', 'a+') { |f| User.find(:all).each { |u|
#f.write("#{u.login}\t#{u.email}\n") } }
  def revit_keynote_export(project)

  project = Project.where(:id => params[:id]).first 
  filename = project.code + " specright_keynote"
  @bim_revit_export = File.open('#{filename}.txt', 'a+') do |txt|   

      #for each section 
      sections = Cawssection.project_sections(project)                                   
      sections.each_with_index do |section, i|
        #project section    
        txt << ["#{section.ref}\t#{section.text}\n"]  
       
        #for each subsection     
        subsections = Cawssubsection.section_subsections(project, section)               
        subsections.each_with_index do |subsection, n|
          #project subsection  
          txt << ["#{subsection.sprintf("%02d", ref).to_s}\t#{subsection.text}\t#{subsection.section.ref}\n"]
          
          clauses = Clause.subsection_clauses(project, subsection)                 
          clauses.each_with_index do |clause, m|
            #project clauses 
            txt << ["#{clause.clause_code}\t#{clause.clausetitle.text}\t#{clause.clauseref.subsection.cawssubsection.full_code}\n"] 
          end 
        end 
      end
    end  
    send_data @bim_revit_export, :type => 'text/plain', :disposition => 'attachment'      
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


  def bentley_keynote_export(project)
    
    filename = project.code + " specright_keynote"   
    @bim_bentley_export = CSV.generate do |csv|  
      
      #for each section
      sections = Cawssection.project_sections(project)
      sections.each_with_index do |section, i|
        #project section
        csv << [section.ref << ' ' << section.text]
        
        #for each subsection
        subsections = Cawssubsection.section_subsections(project, section) 
        subsections.each_with_index do |subsection, n|
          #project subsection
          csv << [subsection.subsection_code << '*' << subsection.text]
          
          #for each clause
          clauses = Clause.subsection_clauses(project, subsection) 
          clauses.each_with_index do |clause, m|          
            #project clauses
            csv << [clause.clause_code << '*' << clause.clausetitle.text]
          end  
        end
        csv << []        
      end
    end  
    send_data @bim_bentley_export, :type => 'text/plain', :disposition => 'attachment; filename=#{filename}.spc'      
  end


  
  def cadimage_keynote_export(project)
    
    filename = project.code + " specright_keynote"   
    @cadimage_keynote_export = CSV.generate(:col_sep => "\t") do |csv|
      
      #headers
      #set up for columns, unique identifier column to be set to 'Create Unique IDS'
      csv << ['category', 'ignore', 'Keynote Key', 'Short Description', 'Long Description', 'Specfication Ref.', 'Time Stamp']  
      
      #for each section
      subsections = Cawssubsection.all_subsections(project)       
      subsections.each_with_index do |subsection, n|
        #project subsection
        csv << [subsection.full_code, '', subsection.full_code, subsection.text]
        
        #for each clause
        clauses = Clause.subsection_clauses(project, subsection) 
        clauses.each_with_index do |clause, m|           
          #project clauses
          csv << [subsection.full_code, '', clause.clause_code, clause.clausetitle.text]
        end  
      end      
    end  
    send_data @cadimage_keynote_export, :type => 'text/plain', :disposition => 'attachment; filename=#{filename}.txt'      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
    
end