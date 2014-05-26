class Cawssubsection < ActiveRecord::Base
  belongs_to :cawssection
  has_many :subsections

  scope :project_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                           ).where('speclines.project_id' => project.id
                                           ).group(:id
                                           ).order(:id
                                           )} 

#  scope :project_user_subsections, ->(project, current_user) { joins(:subsections => [:susbectionusers => [:projectusers], :clauserefs => [:clauses => :speclines]]
#                                           ).where('speclines.project_id' => project.id, 'projectusers.user_id' => current_user.id
#                                           ).group(:id
#                                           ).order(:id
#                                           )}                                             


  scope :template_subsections, ->(project, template) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                                      ).where('speclines.project_id' => template.id
                                                      ).where.not('speclines.project_id' => project.id
                                                      ).group(:id
                                                      ).order(:id
                                                      )}

#  scope :template_user_subsections, ->(project, template, current_user) { joins(:subsections => [:susbectionusers => [:projectusers], :clauserefs => [:clauses => :speclines]]
#                                                      ).where('speclines.project_id' => template.id, 'projectusers.user_id' => current_user.id
#                                                      ).where.not('speclines.project_id' => project.id
#                                                      ).group(:id
#                                                      ).order(:id
#                                                      )}

  scope :filter_user, ->(current_user) { joins(:subsections => [:susbectionusers => :projectusers]
                                                      ).where('projectusers.user_id' => current_user.id    
                                                      )}


  scope :all_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => @project.id
                                         ).group(:id
                                         ).order(:id
                                         )}


  scope :prelim_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => @project.id
                                         ).where(:cawssection_id => 1
                                         ).group(:id
                                         ).order(:id
                                         )}

  scope :subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => @project.id
                                         ).where.not(:cawssection_id => 1
                                         ).group(:id
                                         ).order(:id
                                         )}

#revisions view
  scope :all_subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                         ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                         ).group(:id
                                         )}

  scope :prelim_subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                         ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                         ).where(:cawssection_id => 1
                                         ).group(:id
                                         )}

  scope :subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                         ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                         ).where.not(:cawssection_id => 1
                                         ).group(:id
                                         )}


  scope :section_subsections, ->(project, section) {joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                   ).includes(:section).where('speclines.project_id' => project.id, :section_id => section.id
                                   ).group(:id).sort 
                                   }

                                            
  def full_code
    return cawssection.ref.to_s + sprintf("%02d", ref).to_s
  end


  def full_code_and_title
    return cawssection.ref.to_s + sprintf("%02d", ref).to_s+' '+text.to_s
  end

  def part_code_and_title
    return sprintf("%02d", ref).to_s+' '+text.to_s
  end

end
