class Guide

  include HTTParty
  base_uri 'specright.co.uk/api/v1'
  default_params :output => 'json'
  format :json
  @api_key = "<my_api_key>"

  def self.find(guide_id)

    get('/guides/#{guide_id}.json', :headers => {'Accept' => 'application/json',
                                       'Content-Type' => 'application/json',
                                       'Authorization' => @api_key,
                                       'Host' => 'api.specright.co.uk'}).body
  end


#HTTParty.post("http://rubygems.org/api/v1/gems/httparty/owners",
#    :query => { :email => "alan+thinkvitamin@carsonified.com" },
#    :headers => { "Authorization" => "THISISMYAPIKEYNOREALLY"})


end