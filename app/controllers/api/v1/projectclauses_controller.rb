
module Api
  module V1
  
    class ProjectclausesController < ApplicationController
      include ActionController::HttpAuthentication::Token
      before_filter :check_project_user
      respond_to :json

      def index
        #return list of clauses
        #json return = [{'refence':'code', 'title':'text'},{'refence':'code', 'title':'text'},..]
      end

      def create
        #create clause in project
        #required params[:ref, :title]
        #json return success or fail (reason - data or duplicate)
        
        #method here
          #deconstruct params[:ref]
        
        #record change
        
        #return json response
      end

      def destroy
        #delete clause from project
        #json return success or fail (reason - dos not exist)
        
        #method here
        
        #record change
        
        #return json response
      end


    private

      def project_params
        params.require(:project).permit(:project_id, :clause_id, :attribute, :value)
      end

      def check_project_user
        #check user is allowed to access selected project for company
        #
        #check project
        #risk of same project name and ref accross all projects where managed by project user
        
        #project_ref, project_title, project_company
        #
        #project_user = Projectuser.join(:project, :user
        #                         ).where(:project_id =>params[:project_id], :user_id => current_user.id
        #                         ).first
        #if project_user.blank?
          #format json: render{nothing: true, status: :forbidden}
        #end
      end

    end
  end
end
