class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  helper_method :current_user 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


 protected 
 
  def check_project_status_change(project, revision)
    previous_statuses = Revision.where(:project_id => project.id).pluck(:project_status)
    
    if previous_statuses.length >= 3 
      @previous_revision_project_status = previous_statuses[previous_statuses.length - 2]                        
      if revision.project_status != @previous_revision_project_status
        @project_status_changed = true
      end
    end
  end

#speclines controller - new_specline action
  def update_subsequent_specline_clause_line_ref(subsequent_lines, action, specline)

    subsequent_lines.each_with_index do |line, i|
      if action == 'new'
        line.update(:clause_line => specline.clause_line + 2 + i)
      end
      if action == 'delete'
        line.update(:clause_line => specline.clause_line + i)
      end
    end
       
  end


  def update_clause_change_records(project, revision, clause_ids, event_type)

    #estabish current revision for project
    revision = Revision.where('project_id = ?', @project.id).last

    #check if there have been any changes to the clauses to be deleted within the current revision (since the project was last issued)
    #if there are previous changes update change event record
    #illustrate that all lines within the clause have been deleted as part of subsection deletion event (3)
    previous_changes = Alteration.where(:project_id => project.id, :clause_id => params[:project_clauses], :revision_id => revision.id)
    if previous_changes
      previous_changes.each do |previous_change|
        previous_change.update(:clause_add_delete => event_type)
      end    
    end
  
  end


  def record_delete(specline, event_type)
    #get current revision for project 
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_record.blank?
          #define if change action applied to line, clause or section
          #information used when reporting changes and upon reinstatement
          set_event_type(event_type)

          #set update hash of specline data for creating new change records
          specline_hash(specline, revision)
           
          #if no previous changes for specline create delete record for l ine                     
          new_delete_rec = Alteration.create(@specline_hash.merge(:event => 'deleted',
                                                                  :specline_id => specline.id,
                                                                  :clause_add_delete => @clause_add_delete)) 
        else
          #where previous 'new' and 'change' events have been reorded
          #'delete' events not checked as none will exist for selected line (you cannot select a line that has already been deleted)
          #if a change has been previously made to selected specline then...
          if existing_record.event == 'new'
            #if previous change event was creation of new specline then destory change record
            existing_record.destroy
          end
          
          if existing_record.event == 'changed'
            #if previous change was for change to specline then amend action to 'delete' from 'change'
            existing_record.update(:event => 'deleted', :user_id => current_user.id)
          end
        end
      end
    end   
  end


  def record_new(specline, event_type)
    #get current revision for project     
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'                       
        #set update hash of specline data for creating new change records
        specline_hash(specline, revision)
        #define if change action applied to line, clause or section
        #information used when reporting changes and upon reinstatement     
        set_event_type(event_type)
        #check if any changes already made for selected specline in current revision
        #check by rev_id, txts and linetype as 'new' line may match an existing line or previous change record
        #private method in application controller
        text_match_previous_alterations(specline, revision)
        if @match_previous.blank?     
            #if no previous changes for specline create new record for line 
            new_new_rec = Alteration.create(@specline_hash.merge(:event => 'new',
                                                                 :specline_id => specline.id,
                                                                 :clause_add_delete => @clause_add_delete)) 
        else
            #update specline_id of all precious changes for existing change record specline with specline of new line
            update_specline_id_prior_changes(@match_previous.specline_id, specline.id)  

            #if previous action was 'delete'do not create 'new' change record            
            #delete change record, as this line has no longer been deleted, but re-created      
            
            if @match_previous.event == 'changed'
              #if previous action was 'change'
              #create 'new' change record for current specline with id of old change  
              new_new_rec = Alteration.create(@specline_hash.merge(:event => 'new',
                                                                   :specline_id => @match_previous.specline_id,
                                                                   :clause_add_delete => @clause_add_delete))
            end
            @match_previous.destroy         
        end   
        #'delete' event not relevant because a line that has been previously deleted cannot be subsequently altered or re-created
      end        
    end
  end


  def record_change(old_specline, new_specline)

    #changes can only be applied to line
    #information used when reporting alterations and upon reinstatement 
    clause_add_delete = 1
    
    #get current revision for project     
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record alteration if project has not been prevsiously issued (not in draft) 
      if revision.rev.to_s >= 'a'                       
        #check if any alterations already made to selected specline in current revision
        #check by rev_id, txts and linetype as 'new' line may match an existing line or previous alteration record
        #private method in application controller
        new_match_previous_alterations(new_specline, revision)
        if @match_new_line_content
        #if NEW content DOES equal the old content of any other altered line (that has been previously 'deleted' or 'changed'). 
          #if new content matches the old content of a 'new' alteration record two copies of the same content will exist
          #...the existing 'new' alteration record doe not therefore need to be changed.

        #set update hash of specline data for creating new alteration records
#old content
          specline_hash(old_specline, revision)      
          #if previous action was 'delete'
          if @match_new_line_content.event == 'deleted'
            
            #update specline_id of all previous changes for existing change record specline with specline of new line
#????update matching with current_id
            update_specline_id_prior_changes(@match_new_line_content.specline_id, specline.id)

#old content
            specline_hash(old_specline, revision)
            #create 'deleted' change record for current specline
            new_delete_rec = Alteration.create(@specline_hash.merge(:event => 'deleted',
                                                                    :specline_id => @match_new_line_content.specline_id,
                                                                    :clause_add_delete => @clause_add_delete))                            
            #delete change record, as this line has no longer been changed, but re-created
            @match_new_line_contents.destroy            
          end          

          #if previous action was 'changed' then line will have changed back to original
          if @match_new_line_content.event == 'changed'              
            #line_id of existing alteration record to be assigned to previous alterations of current line
            
            #update specline_id of all previous changes for existing change record specline with specline of new changed line
#????update current with matching line_id
            update_specline_id_prior_changes(@match_new_line_content.specline_id, @specline.id)                        
#old content
            new_new_rec = Alteration.create(@specline_hash.merge(:event => 'changed',
                                                                 :specline_id => specline.id,
                                                                 :clause_add_delete => @clause_add_delete))                           
            ##???? - what does this do
            @match_new_line_content.destroy          
          end            
        #if NEW content DOES NOT equal the old content of any other altered line (that has been previously 'deleted' or 'changed').                    
        #check if any alterations already made for selected specline in current revision
        else
          old_match_previous_alterations(old_specline, revision)
          #if OLD content DOES equals a 'new' alteration record
          #then new content should be assigned to existing 'new' alteration record and no change record crea
          if @match_old_line_content 
            #if previous action was 'new' then update content of change record
            #set update hash of specline data for creating new alteration records
            existing_record = Alteration.where(:specline_id => specline.id).first
            if existing_record     
#new content
              specline_hash(new_specline, revision)
              existing_record.update(@specline_hash)                                            
            end        
          else                    
            existing_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
            if existing_record.blank?         
              #if no previous alterations for specline create 'change' record for line 
#old content
              specline_hash(old_specline, revision)
              new_new_rec = Alteration.create(@specline_hash.merge(:event => 'changed',
                                                                   :specline_id => specline.id,
                                                                   :clause_add_delete => @clause_add_delete))     
            else
              #if previous alteration to line was 'new'
              if existing_record.event == 'new'
              #udpate existing 'new' alteration record to reflect latest line information        
#new content
                specline_hash(new_specline, revision)
                existing_record.update(@specline_hash)                    
              end
              #if existing 'change' alteration record exists then do nothing because original chang record still valid
              #'delete' event not relevant because a line that has been previously deleted cannot be subsequently altered or re-created         
            end   
          end
        end    
      end   
    end  
  end


def txt1_insert_line(specline, previous_specline, subsequent_specline_lines)
  check_linetype = Linetype.find(previous_specline.linetype_id)
  if check_linetype.txt1 == true
    specline.txt1_id = previous_specline.txt1_id + 1
    specline.save
    
   if subsequent_specline_lines.count == 1
     update_subsequent_lines_last(subsequent_specline_lines, specline.txt1_id)    
   else
    update_subsequent_lines(subsequent_specline_lines, specline.txt1_id)
  end
  end
end

                                                                                                                                           
def txt1_delete_line(specline) 
  check_linetype = Linetype.find(specline.linetype_id)

  previous_clauseline = specline.clause_line - 1 
    previous_line = Specline.where("project_id = ? AND clause_id = ? AND clause_line = ?", specline.project_id, specline.clause_id, previous_clauseline).order("clause_line").last
    check_linetype = Linetype.find(previous_line.linetype_id)
      if check_linetype.txt1 == true
        set_txt1_id = previous_line.txt1_id
      else
        set_txt1_id = 0
      end  
    subsequent_clause_lines = Specline.where("project_id = ? AND clause_id = ? AND clause_line > ?", specline.project_id, specline.clause_id, specline.clause_line).order("clause_line")
    update_subsequent_lines(subsequent_clause_lines, set_txt1_id)

end


def txt1_change_linetype(specline, old_linetype, new_linetype)

  if old_linetype.txt1 == true
    if new_linetype.txt1 == false
      specline.txt1_id = 1
      specline.save
      set_txt1_id = 0
    end
  else
    if new_linetype.txt1 == true
      previous_clauseline = specline.clause_line - 1   
      previous_line = Specline.where("project_id = ? AND clause_id = ? AND clause_line = ?", specline.project_id, specline.clause_id, previous_clauseline).order("clause_line").last
      check_linetype = Linetype.find(previous_line.linetype_id)
      if check_linetype.txt1 == true
        specline.txt1_id = previous_line.txt1_id + 1
        set_txt1_id = previous_line.txt1_id + 1 
      else
        specline.txt1_id = 1
        set_txt1_id = 1
      end                                        
      specline.save  
    end
  end
  subsequent_clause_lines = Specline.where("project_id = ? AND clause_id = ? AND clause_line > ?", specline.project_id, specline.clause_id, specline.clause_line).order('clause_line')
  update_subsequent_lines(subsequent_clause_lines, set_txt1_id)  
end


  def update_subsequent_lines(subsequent_lines, set_txt1_id)
    @subsequent_prefixes = []
    
    subsequent_lines.each_with_index do |next_line, i|
  
      check_linetype = Linetype.where('id =?', next_line.linetype_id).first
      if check_linetype.txt1 == true
        next_txt1_id = (set_txt1_id + 1 + i)
        next_line.update(:txt1_id => next_txt1_id)
        
        next_txt1_text = Txt1.where(:id => next_txt1_id).first
        @subsequent_prefixes[i] = [next_line.id, next_txt1_text.text] 
      else
        break
      end
    end
  end



  def update_subsequent_lines_last(subsequent_lines, set_txt1_id)
    
    subsequent_lines.each_with_index do |next_line, i|
      check_linetype = Linetype.where('id =?', next_line.linetype_id).first
      if check_linetype.txt1 == true
        next_txt1_id = (set_txt1_id + i)
        next_line.update(:txt1_id => next_txt1_id)
      else
        break
      end
    end
    
  end



  private
 
    def permission_denied
      session[:user_id] = nil  
      redirect_to home_path 
    end
  
    def current_user  
      @current_user ||= User.find(session[:user_id]) if session[:user_id]  
    end
  
    def authenticate
      #@current_user ||= User.find(session[:user_id]) if session[:user_id]
      #if @current_user.role == 'user'
      #   redirect_to log_out_path
      #end    
      redirect_to log_out_path unless current_user
    end
  
    def authenticate_owner
      redirect_to log_out_path unless current_user.role == "owner"
    end


#user_role(["admin", "owner", "employee"])
#project_role(@project, ["manage", "publish", "write", "read"])

#  def authorise_user_view(permissible_roles)
#    if permissible_roles.include?(@current_user.role)
#      return true
#    end      
#  end


 



#  def subsection_action(project_id, subsection_id, permissible_roles)
#    permitted_user = Projectuser.joins(:subsectionusers
#                               ).where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles
#                               ).where.not('subsectionusers.subsection_id' => subsection_id
#                               ).first    
#    if permitted_user.blank?
#       redirect_to log_out_path
#    end      
#  end



#  def authorise_specline_action(specline_id, permissible_roles)
#    permitted_user = Subsectionuser.where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles).first    
#    if permitted_user.blank?
#       redirect_to log_out_path
#    end      
#  end




    def new_match_previous_alterations(specline, revision)      
      specline_find_hash(specline, revision)      
      @match_new_line_content = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(@specline_match_hash).where.not(:event => 'new').first
    end

    def old_match_previous_alterations(specline, revision)      
      specline_find_hash(specline, revision)      
      @match_old_line_content = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(@specline_match_hash).where.not(:event => ['changed', 'deleted']).first
    end
   
    def specline_find_hash(specline, revision)
          @specline_match_hash = {}      
          linetype = Linetype.where(:id => specline.linetype_id).first
          
          if linetype[:txt3] == true     
            @specline_match_hash['txt3s.text'] = specline.txt3.text
          end
          if linetype[:txt4] == true     
            @specline_match_hash['txt4s.text'] = specline.txt4.text
          end
          if linetype[:txt5] == true     
            @specline_match_hash['txt5s.text'] = specline.txt5.text
          end
          if linetype[:txt6] == true     
            @specline_match_hash['txt6s.text'] = specline.txt6.text
          end
          if linetype[:identity] == true     
            @specline_match_hash['identities.id'] = specline.identity.id
          end
          if linetype[:perform] == true     
            @specline_match_hash['performs.id'] = specline.perform.id
          end            
          @specline_match_hash[:revision_id] = revision.id
          @specline_match_hash[:project_id] = specline.project_id
          @specline_match_hash[:clause_id] = specline.clause_id
          @specline_match_hash[:linetype_id] = specline.linetype_id        
    end


  
      #update specline_id of all previous changes to the same line
      def update_specline_id_prior_changes(previous_id, new_id)
        
        prior_changes = Alteration.where(:specline_id => previous_id)
        prior_changes.each do |change|
          change.update(:specline_id => new_id)
        end  
      end

     def specline_hash(specline, revision)  
       @specline_hash = {:project_id => specline.project_id,
                        :clause_id => specline.clause_id,                        
                        :txt3_id => specline.txt3_id,               
                        :txt4_id => specline.txt4_id,
                        :txt5_id => specline.txt5_id,
                        :txt6_id => specline.txt6_id,
                        :identity_id => specline.identity_id,
                        :perform_id => specline.perform_id,
                        :linetype_id => specline.linetype_id,
                        :revision_id => revision.id,
                        :user_id => current_user.id,
                        :print_change => 1 }       
      end 

      def set_event_type(event_type) 
          if event_type.blank?
             @clause_add_delete = 1
          else
             @clause_add_delete = event_type
          end
          return @clause_add_delete
      end
  
end
