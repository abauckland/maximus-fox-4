class User < ActiveRecord::Base

  has_many :projects, :through => :projectusers
  belongs_to :company
  
  #declare an enum attribute where the values map to integers in the database, but can be queried by name
  enum role: [:admin, :owner, :employee]

 
  before_save :encrypt_password  
#  after_create :add_user_to_mailchimp
  

  validates :password,   
            :presence => {:message => "can't be black"},
            on: :create,   
            :length => {:minimum => 8, :message => "must be minimum 8 characters long"}   

  validates :email,   
            :presence => true,
            on: :create,   
            :uniqueness => {:message => "A user with this email address already exists"},
            :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, }  

  
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
    return first_name+' '+surname
  end
  
end
