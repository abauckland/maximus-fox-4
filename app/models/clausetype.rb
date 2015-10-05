class Clausetype < ActiveRecord::Base
#associations
  has_many :clauserefs
  has_many :lineclausetypes
  has_many :subsections, :through => :clauserefs


#used
  scope :subsection_clausetypes, ->(project, selected_subsection, subsection_name) { 
                                    joins(:clauserefs => [:subsection, :clauses => [:speclines]]
                                  ).where('speclines.project_id' => project, 'subsections.'+subsection_name+'_id' => selected_subsection.id
                                  ).group(:id
                                  ).order(:id
                                  )}


end
