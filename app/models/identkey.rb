class Identkey < ActiveRecord::Base
  #associations
  has_many :identities
end
