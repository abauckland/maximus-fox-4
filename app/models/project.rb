class Project < ActiveRecord::Base
#associations
  has_many :projectusers
  has_many :users, :through => :projectusers
  has_many :speclines
  has_many :clauses, :through => :speclines
  has_many :revisions
  has_many :alterations
#TODO belongs_to :printsettings - need to amend database
  has_many :printsettings
  has_many :prints
#TODO  belongs_to :refsystem
#TODO  belongs_to :plan
  
  mount_uploader :project_image, ProjectImageUploader
  mount_uploader :client_logo, ClientLogoUploader 


  enum project_status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]
#TODO  remove ref system enum
  enum ref_system: [:CAWS, :Uniclass_2]


  validates :code, presence: true,
#TODO  unique to all projects when collaboration working
    uniqueness: {:scope => [:company_id, :title], message: ": A project with the same code and title already exists for the company" }
  validates :title, presence: true
#TODO  validates :refsystem_id, presence: true

  scope :user_projects, ->(current_user) { joins(:projectusers).where('projectusers.user_id' => current_user.id)}

  scope :project_template, ->(project) { where(:id => project.id).first }

  scope :project_templates, ->(project, current_user) { joins(:projectusers
                              ).where('projectusers.user_id' => current_user.id, :ref_system => project.ref_system
                              ).where.not(:id => project.id
                              ).order("code")}
#TODO                               ).where('projectusers.user_id' => current_user.id, :refsystem_id => project.refsystem_id

  scope :cawssubsections, ->(subsection) { joins(:speclines => [:clause => [:clauseref => :subsection]]
                              ).where('subsections.cawssubsection_id' => subsection.id
                              )}

  scope :ref_system, ->(project) { where(:ref_system => project.ref_system) }
#TODO  scope :ref_system, ->(project) { where(:refsystem_id => project.refsystem_id) }


  def code_and_title
    return code+' '+title
  end


end
