class Projectuser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
#  has_many :subsectionusers
#  has_many :subsections, :through => :subsectionusers

  attr_accessor :email

  enum role: [:manage, :edit, :write, :read]

#  validates :date_from, presence: true
#  validates :date_to, presence: true

#before_save :assign_user

  #manage - manages access to project plus all other functions
  #edit - can fully edit and publish project but cannot manage access
  #write - can edit speclines and clauses but not add subsections, publish or manager access
  #read - can read document only 

#validate that entered email does equal a registered user
#does not work with create first user for project
#  before_validation :custom_validate_email, on: :create

#  def custom_validate_email
#    user = User.where(:email => @email
#              ).where.(:email => current_user.email
#              ).first
#    if user.blank?
#      errors.add(:email, "No matching user found")
#    end
#  end

#  private
#    def assign_user
#      unless @user_id
#        user = User.where(:email => @email).first
#        self.user_id = user.id
#      end
#    end



end
