class FeaturesController < ApplicationController
  before_action :set_feature, only: [:show]

  layout "websites"

  # GET /featurees
  # GET /featurees.json
  def index
    @features = Feature.all
  end

  # GET /featurees/1
  # GET /featurees/1.json
  def show
    @contents = Featurecontent.where(:feature_id => @feature.id)      
    @menu_contents = Feature.where.not(:id => @feature.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_params
      params.require(:feature).permit(:title, :text, :image)
    end
end
