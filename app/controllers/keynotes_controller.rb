class KeynotesController < ApplicationController

  before_action :set_project, only: [:show, :keynote_export]
  before_action :set_revision, only: [:show]

  include ProjectuserDetails
  include RefsystemSettings

  layout "projects"


  def show
    authorize :keynote, :show?
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)

  end


  def keynote_export
    authorize :keynote, :keynote_export?

    case params[:cad_product]
      when 'csv' ;              csv_keynote(@project)
      when 'revit' ;            revit_keynote(@project)
      when 'bentley' ;          bentley_keynote(@project)
      when 'cadimage' ;         cadimage_csv(@project)
      when 'cadimage_keynote' ; cadimage_keynote(@project)
    end

  end


private

  def csv_keynote(project)

    #set up for columns, unique identifier column to be set to 'Create Unique IDS'
    headers = ['ref', 'title', 'ref & title']

    @csv_keynote = CSV.generate do |csv|

      csv << headers

      set_subsections(project)
      @subsections.each_with_index do |subsection, n|
        #project subsection
        subsection_code = subsection.full_code.to_s
        subsection_title = subsection.text.to_s
        csv << [subsection_code, subsection_title]

        #for each clause
        set_clauses(project, subsection, @subsection_name)
        @clauses.each_with_index do |clause, m|

          clause_code = subsection_code + '.' +clause.clauseref_code.to_s
          clause_full_title = subsection_code + '.' +clause.clauseref_code.to_s + ' ' +clause.clausetitle.text.to_s
          csv << [clause_code, clause.clausetitle.text, clause_full_title]
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
        data = data + "#{s.ref}\t#{s.text}\r\n"
        #for each subsection
        set_section_subsections(project, s)
        @subsections.each_with_index do |subsection, n|

          #project subsection s
          subsection_code = subsection.full_code.to_s
          subsection_title = subsection.text.to_s
          section_code = subsection.method(set_section_name(project)).call.ref.to_s

          data = data + "#{subsection_code}\t#{subsection_title}\t#{section_code}\r\n"

          set_clauses(project, subsection, @subsection_name)
          @clauses.each_with_index do |clause, m|
            #project clauses
            clause_code = subsection_code + '.' +clause.clauseref_code.to_s
            data = data + "#{clause_code}\t#{clause.clausetitle.text}\t#{subsection_code}\r\n"
          end
        end
      end
     send_data( data, :filename => "#{project.title}_revit_keyontes.txt" )
  end


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


  def cadimage_csv(project)
  
    #set up for columns, unique identifier column to be set to 'Create Unique IDS'
    headers = ['Unique ID', 'Key', 'Title', 'Description', 'Reference', 'Last Edit Time', 'Category']

    @cadimage_keynote = CSV.generate do |csv|

      csv << headers

      set_subsections(project)
      @subsections.each_with_index do |subsection, n|
        #project subsection
        subsection_code = subsection.full_code.to_s
        subsection_title = subsection.text.to_s
        csv << ['', subsection_code, subsection_title, '', '', '', '']

        #for each clause
        set_clauses(project, subsection, @subsection_name)
        @clauses.each_with_index do |clause, m|
          #project clauses
          clause_code = subsection_code + '.' +clause.clauseref_code.to_s
          csv << ['', clause_code, clause.clausetitle.text, '', '', '', subsection_code]
        end
      end
    end

    filename = "#{@project.code}_cadimage_keynote.csv"

    send_data @cadimage_keynote, filename: filename, :type => 'text/csv'
  end


  def cadimage_keynote(project)
    require "rubygems"
    require "nokogiri"

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.keynoteAttributes {
        xml.keynoteDatabase {
          xml.records {

          set_subsections(project)

          @subsections.each do |subsection|
            subsection_code = subsection.full_code.to_s
            subsection_title = subsection.text.to_s
            sub_key = subsection.id.to_s+"-0000-00"
            xml.keynote(:key => sub_key, :edit => Time.now.to_formatted_s(:iso8601)) {
              xml.name subsection_code
              xml.title subsection_title
            }

            set_all_clauses(project, subsection, @subsection_name)

            @clauses.each do |clause|
            clause_code = subsection_code + '.' +clause.clauseref_code.to_s
            clause_key = subsection.id.to_s+"-"+clause.clauseref_id.to_s+"-00"
            xml.keynote(:key => clause_key, :edit => Time.now.to_formatted_s(:iso8601)) {
              xml.name clause_code
              xml.parent_ sub_key
              xml.title clause.clausetitle.text
              }

              set_lines(project, clause)

              @lines.each_with_index do |line, i|
              line_key = subsection.id.to_s+"-"+clause.clauseref_id.to_s+"-"+line.id.to_s
              xml.keynote(:key => line_key, :edit => Time.now.to_formatted_s(:iso8601)) {
                xml.parent_ clause_key
                xml.description line.txt4.text
                }
              end
            end
          end
            
          }
        }
      }
    end

    filename = "#{@project.code}_cadimage_keynote.keynote"
    send_data builder.to_xml, filename: filename, :type => 'text/xml'

  end


    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_sections(project)
        @sections = @section_model.project_sections(project)#.where.not(:id => 1)
    end

    def set_subsections(project)
        @subsections = @subsection_model.project_subsections(project)
    end

    def set_section_subsections(project, section)
        @subsections = @subsection_model.section_subsections(project, section)
    end

    def set_clauses(project, subsection, subsection_name)
        @clauses = Clause.subsection_clauses(project, subsection, subsection_name).where('clauserefs.clausetype_id' => [2..5])
    end

    def set_all_clauses(project, subsection, subsection_name)
        @clauses = Clause.subsection_clauses(project, subsection, subsection_name)
    end

    def set_lines(project, clause)
        #return only lines relating to scope, workmanship, testing and certificates
        @lines = Specline.joins(:clause => :clauseref).where(:project_id => project.id, :clause_id => clause.id, 'clauserefs.clausetype_id' => [6..8])#.order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause, clause_line')
    end


    def set_revision
      if params[:revision_id].blank?
        @revision = Revision.where(:project_id => params[:id]).order('created_at').last
      else
        @revision = Revision.find(params[:revision_id])
      end
    end


end