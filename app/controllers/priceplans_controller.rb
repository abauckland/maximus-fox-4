class PriceplansController < ApplicationController

  layout "websites"
  
  # GET /faqs
  # GET /faqs.json
  def index
    @priceplans = Priceplan.includes(:planfeatures).all
  end

end
