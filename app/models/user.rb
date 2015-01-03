class User < ActiveRecord::Base

  has_many :projectusers
  has_many :projects, :through => :projectusers
  has_many :prints
  has_many :alterations
  belongs_to :company
  
  #declare an enum attribute where the values map to integers in the database, but can be queried by name
  enum role: [:admin, :owner, :employee]

  attr_accessor :password, :password_confirmation
 
  before_save :encrypt_password  
#  after_create :add_user_to_mailchimp
  
  validates :first_name,   
            :presence => {:message => "First name cannot be blank"}

  validates :surname,   
           :presence => {:message => "Surname cannot be blank"}

  validates :password,   
            :presence => {:message => "Password cannot be blank"},
            on: :create,   
            :length => {:minimum => 8, :message => "Password must be minimum 8 characters long"}   

  validates :email,   
            :presence => true,
            on: :create,
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, },    
            :uniqueness => {:message => "A user with this email address already exists"}
             

  
  def encrypt_password  
    if password.present?  
      self.password_salt = BCrypt::Engine.generate_salt  
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
    end  
  end 
  
  def self.authenticate(email, password)  
    user = find_by_email(email)  
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    user  
    else  
      nil  
    end  
  end 

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end 

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
   
  
  def name
    return first_name.capitalize+' '+surname.capitalize
  end

  
#  def add_user_to_mailchimp  
#    mailchimp = Gibbon::API.new('4d0b1be76e0e5a65e23b00efa3fe8ef3-us5')
  
#    mailchimp.lists.subscribe({:id => 'c65ee7deb5', :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.surname}, :double_optin => false, :send_welcome => true, })
   # mailchimp.lists.subscribe({:id => '01239b3a0f', :email => {:email => self.email}, :merge_vars => {:FNAME => self.first_name, :LNAME => self.surname}, :double_optin => false, :send_welcome => true, })    
#  end

  
end
