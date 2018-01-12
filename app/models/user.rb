class User < ActiveRecord::Base

  include AASM

  has_many :projectusers
  has_many :projects, :through => :projectusers
  has_many :prints
  has_many :alterations
  belongs_to :company

  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :lockable, :rememberable#,
   # :encryptable, :encryptor => "authlogic_sha512"
  attr_accessor :check_field
  accepts_nested_attributes_for :company

  before_validation :custom_validation_check_field, on: :create 
   after_create :default_settings

  #declare an enum attribute where the values map to integers in the database, but can be queried by name
  enum role: [:admin, :owner, :employee]

#  attr_accessor :password, :password_confirmation
 
#  before_save :encrypt_password

  aasm :column => 'state' do

    state :active#, :initial => true
    state :inactive

    event :deactivate do
      transitions :from => :active, :to => :inactive
    end

    event :activate do
      transitions :from => :inactive, :to => :active
    end
  end


#  after_create :add_user_to_mailchimp

    validates :first_name,
      :presence => {:message => "First name cannot be blank"},
      format: { with: NAME_REGEXP, message: "please enter a valid name" }

    validates :surname,
      :presence => {:message => "Surname cannot be blank"},
      format: { with: NAME_REGEXP, message: "please enter a valid name" }
 
  def custom_validation_check_field
    if @check_field !=''
      errors.add(:check_field, "Cannot be blank")
    end
  end 
 
  
#  validates :password,   
#            :presence => {:message => "Password cannot be blank"},
#            on: :create,   
#            :length => {:minimum => 8, :message => "Password must be minimum 8 characters long"}   

#  validates :email,   
#            :presence => true,
#            on: :create,
#            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, },    
#            :uniqueness => {:message => "A user with this email address already exists"}


  def default_settings
    #only create initial project if first user for the company
    user_count = User.where(:company_id => self.company_id).count(:id)

    if user_count == 1

      initial_project = Project.create(:company_id => self.company_id, :code => 'D1', :title => 'Demo Project', :parent_id => 1, :project_status => 'Draft', :ref_system => 'CAWS')
      project_template = Project.where(:id => [1..10], :ref_system => initial_project.ref_system).first
      initial_project.update(:parent_id => project_template.id)

      Projectuser.create(:project_id => initial_project.id, :user_id => self.id, :role => "manage")
      Printsetting.create(:project_id => initial_project.id)
      Revision.create(:project_id => initial_project.id, :user_id => self.id, :date => Date.today)

    else

      projects =  Project.where(:company_id => self.company_id)
      projects.each do |project|
        Projectuser.create(:project_id => project.id, :user_id => self.id, :role => "manage")
      end

    end

  end

#  def encrypt_password  
#    if password.present?  
#      self.password_salt = BCrypt::Engine.generate_salt  
#      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
#    end  
#  end 
  
#  def self.authenticate(email, password)  
#    user = find_by_email(email)  
#    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
#    user  
#    else  
#      nil  
#    end  
#  end 

#  def send_password_reset
#    generate_token(:password_reset_token)
#    self.password_reset_sent_at = Time.zone.now
#    save!
#    UserMailer.password_reset(self).deliver
#  end 

#  def generate_token(column)
#    begin
#      self[column] = SecureRandom.urlsafe_base64
#    end while User.exists?(column => self[column])
#  end
   
  
  def name
    return first_name.capitalize+' '+surname.capitalize
  end

  
#  def add_user_to_mailchimp  
#    mailchimp = Gibbon::API.new('4d0b1be76e0e5a65e23b00efa3fe8ef3-us5')
  
#    mailchimp.lists.subscribe({:id => 'c65ee7deb5', :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.surname}, :double_optin => false, :send_welcome => true, })
   # mailchimp.lists.subscribe({:id => '01239b3a0f', :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.surname}, :double_optin => false, :send_welcome => true, })    
#  end

  
end
