class Identvalue < ActiveRecord::Base
    #associations
    has_many :identities
    belongs_to :identtxt
    belongs_to :company
end
