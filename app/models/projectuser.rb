class Projectuser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :subsectionusers
  has_many :subsections, :through => :subsectionusers

  attr_accessor :email
  attr_accessor :subsections
  
  enum role: [:manage, :edit, :write, :read]  
  #manage - manages access to project plus all other functions
  #edit - can fully edit and publish project but cannot manage access
  #write - can edit speclines and clauses but not add subsections, publish or manager access
  #read - can read document only 


  before_validation :custom_validation, on: :create  


  def custom_validation
    user = User.where(:email => :email).first
    
    if user.blank?
      errors.add(:email, "No matching user found")
    end     
  end

       
end
