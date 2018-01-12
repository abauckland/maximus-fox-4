class Product < ActiveRecord::Base
#associations  
  has_many :clauseproducts
  has_many :descripts
  has_many :identities, :through => :descripts
  has_many :instances
  belongs_to :producttype


#  include HTTParty
#  base_uri 'specright.co.uk/api/v1'
#  default_params :output => 'json'
#  format :json
#  @api_key = "<my_api_key>"

#  def self.find(item_id, selected_key, content)

#{item_id: id, selected_key:text, content: [{line_1: {key:text, value:text},{line_1: {key:text, value:text}]}


#    get('/guides/#{guide_id}.json', :query => {:item_id => item_id, :selected_key => selected_key, :content => content},
#                                    :headers => {'Accept' => 'application/json',
#                                       'Content-Type' => 'application/json',
#                                       'Authorization' => @api_key,
#                                       'Host' => 'api.specright.co.uk'}).body
#  end


end
