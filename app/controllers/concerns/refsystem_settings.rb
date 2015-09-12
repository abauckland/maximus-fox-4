module RefsystemSettings
  extend ActiveSupport::Concern

  included do
    before_filter :section_names
  end


  def section_names
#TODO change ref system establishment
#    if @project.CAWS?
      @subsection_name = 'cawssubsection'
      @subsection_model = @subsection_name.classify.constantize
      @section_name = 'cawssection'
      @section_model = @subsection_name.classify.constantize
#    end
  end

end