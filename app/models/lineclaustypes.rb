class Lineclaustypes < ActiveRecord::Base
  #associations
  belongs_to :clausetypes
  belongs_to :linetypes
end
