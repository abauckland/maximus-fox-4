class Cawssubsection < ActiveRecord::Base
  belongs_to :cawssection
  has_many :subsections

  scope :project_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                           ).where('speclines.project_id' => project.id
                                           ).group(:id
                                           ).order(:id
                                           )}  
#filtered by users role and subsectionusers for projectusers
#joins(:subsectionusers).where(subsectionusers.user_id => current_user.id)

  scope :template_subsections, ->(project, template) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                                      ).where('speclines.project_id' => template.id
                                                      ).where.not('speclines.project_id' => project.id
                                                      ).group(:id
                                                      ).order(:id
                                                      )}
                                            
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
