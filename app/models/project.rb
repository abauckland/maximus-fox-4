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
  has_many :clients
  
  accepts_nested_attributes_for :clients
  
  has_attached_file :photo 


  enum project_status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]
  enum ref_system: [:CAWS, :Uniclass_2]

  validates_presence_of :code
  validates_presence_of :title
  
  validates_attachment_content_type :photo, content_type: { content_type: ["image/jpg", "image/png"]}
  
  validates_attachment :photo,
    :on => :create,
    :size => { :in => 0..1000.kilobytes }

  

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
  
  scope :cawssubsection_project_templates, ->(project, subsection, current_user) { joins(:projectusers, :speclines => [:clauses => [:clauserefs => :subsections]]
                              ).where('projectusers.user_id' => current_user.id, :ref_system => project.ref_system
                              ).where('subsections.cawssubsection_id' => subsection.id
                              ).where.not(:id => project.id
                              ).order("code")}

  
  def code_and_title
    return code+' '+title
  end

  def code_and_title_access
    return code+' '+title
  end


  Paperclip.interpolates :normalized_video_file_name do |attachment, style|
    attachment.instance.normalized_image_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.video_image_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
