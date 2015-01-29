class TermcatsController < ApplicationController

  skip_before_filter :authenticate_user!

  layout "devise"

  # GET /terms
  # GET /terms.json
  def index
    @termcats = Termcat.includes(:terms).order(:id)
  end
end
