class Project < ActiveRecord::Base
#associations
  has_many :projectusers
  has_many :users, :through => :projectusers
  has_many :speclines
  has_many :clauses, :through => :speclines
  has_many :revisions
  has_many :alterations
  has_many :printsettings
  has_many :prints
  
  mount_uploader :project_image, ProjectImageUploader
  mount_uploader :client_logo, ClientLogoUploader 


  enum project_status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]
  enum ref_system: [:CAWS, :Uniclass_2]

  validates_presence_of :code
  validates_presence_of :title
  

  

  scope :user_projects, ->(current_user) { joins(:projectusers).where('projectusers.user_id' => current_user.id).order("code")} 
   
  scope :user_projects_access, ->(current_user) { joins(:projectusers
                                ).where('projectusers.user_id' => current_user.id).order('code'
                                )#.each_with_object({ }){ |c, hsh| hsh[c.id] = '#{c.projectcode_and_title} +' '+#{c.projectusers.role}'}
                                }


  scope :project_template, ->(project) { where(:id => project.id).first }

  scope :project_templates, ->(project, current_user) { joins(:projectusers
                              ).where('projectusers.user_id' => current_user.id, :ref_system => project.ref_system
                              ).where.not(:id => project.id
                              ).order("code")}
  
  scope :cawssubsections, ->(subsection) { joins(:speclines => [:clause => [:clauseref => :subsection]]
                              ).where('subsections.cawssubsection_id' => subsection.id
                              )}

  scope :ref_system, ->(project) { where(:ref_system => project.ref_system) }
  
  def code_and_title
    return code+' '+title
  end

  def code_and_title_access
    return code+' '+title
  end


end
