module RefsystemSettings
  extend ActiveSupport::Concern

  included do
    before_filter :section_names
  end

#def section_names
#      @subsection_name = @project.refsystem.subsection
#      @subsection_model = @project.refsystem.subsection.classify.constantize
#      @section_name = @project.refsystem.section
#      @section_model = @project.refsystem.section.classify.constantize
#end

  def section_names
#TODO change ref system establishment
      @subsection_name = 'cawssubsection'
      @subsection_model = @subsection_name.classify.constantize
      @section_name = 'cawssection'
      @section_model = @section_name.classify.constantize
  end

    def set_subsection_name(project)
      @subsection_name
    end


    def set_section_name(project)
      @section_name
    end
end