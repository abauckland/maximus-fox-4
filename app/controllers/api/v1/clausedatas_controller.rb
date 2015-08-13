
module Api
  module V1
  
    class ClausedatasController < ApplicationController
      include ActionController::HttpAuthentication::Token
      before_filter :project_user
      respond_to :json

      def index
        #return list of clause data (speclines of linetypes ???)
        #json return = [{'txt3':'txt4'},{'txt3':'txt4'},..]
      end

      def create
        #create clause data entry (specline of linetype ??)
        #required params[:project_id, :clause_id, txt3, :txt4]
        #json return success or fail (reason - data or duplicate)
        
        #method here
        
        #record change
        
        #return json response
      end

      def update
        #update clause data entry value (specline of linetype ??)
        #required params[:project_id, :clause_id, :txt3, :txt4]
        #json return success or fail (reason - data or duplicate)
        
        #method here
        
        #record change
        
        #return json response
      end


      def destroy
        #delete clause data (specline)
        #required params[:project_id, :clause_id, :txt3, :txt4]
        #json return success or fail (reason - dos not exist)
        
        #method here
        
        #record change
        
        #return json response
      end


    private
 
      def project_user
        #check user is allowed to access selected project
      end

    end
  end
end
