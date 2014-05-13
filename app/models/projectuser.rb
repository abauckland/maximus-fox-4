class Projectuser < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :subsectionusers
  has_many :subsections, :through => :subsectionusers
  
  enum role: [:manage, :edit, :write, :read]  
  #manage - manages access to project plus all other functions
  #edit - can fully edit and publish project but cannot manage access
  #write - can edit speclines and clauses but not add subsections, publish or manager access
  #read - can read document only 
  
       
end
