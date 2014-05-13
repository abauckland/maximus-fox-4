class TermcatsController < ApplicationController

  layout "websites"

  # GET /terms
  # GET /terms.json
  def index
    @termcats = Termcat.includes(:terms).order(:id)
  end
end
