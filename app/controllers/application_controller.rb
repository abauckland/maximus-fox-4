class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  helper_method :current_user 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


 protected 


  
#project action => manage_subsections  
  def current_revision_render(project)

    revisions = Revision.where(:project_id => project.id).order('created_at')         
    last_rev_check = Alteration.where(:project_id => project.id, :revision_id => revisions.last.id).first
    if last_rev_check.blank?
      #count of revision records indicates the revision rev no
      #first revision record, when document is in draft - rev == NULL
      #second revision records, when document has been issued for the first time - rev == '-'
      #third revision record, when document has been issued and then revised - rev =='a'
      
      #if no changes recorded for current revision record then last record still applies
      #reduce record count by 1 to indicate this
      rev_number = revisions.count
      current_rev_number = rev_number-1
    end  
    
    if current_rev_number == 0 #revision rev == NULL
      @current_revision_rev = 'n/a'
    else  
      if current_rev_number == 1 #revision rev == '-'
        @current_revision_rev = '-'
      else    
        @current_revision_rev = revisions.last.rev.capitalize
      end
    end
  end  


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
    if revision
      #set update hash of specline data for creating new change records
      specline_hash(specline, revision)

      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_record.blank?
          #define if change action applied to line, clause or section
          #information used when reporting changes and upon reinstatement
          set_event_type(event_type)
           
          #if no previous changes for specline create delete record for line                     
          new_delete_rec = Alteration.create(@specline_hash.merge(:specline_id => specline.id,
                                                                  :clause_add_delete => @clause_add_delete,
                                                                  :event => 'deleted')) 
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
    if revision
      #set update hash of specline data for creating new change records
      specline_hash(specline, revision)
      #define if change action applied to line, clause or section
      #information used when reporting changes and upon reinstatement     
      set_event_type(event_type)
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'                       
      #check if any changes already made for selected specline in current revision
      #check by rev_id, txts and linetype as 'new' line may match an existing line or previous change record
      #private method in application controller
      specline_current_text_match_check(specline, revision)
      if @check_new_match_previous.blank?
   
          #if no previous changes for specline create new record for line 
          new_new_rec = Alteration.create(@specline_hash.merge(:specline_id => specline.id,
                                                                 :clause_add_delete => @clause_add_delete,
                                                                 :event => 'new')) 
      else
        #update specline_id of all precious changes for existing change record specline with specline of new line
        update_specline_id_prior_changes(@check_new_match_previous.specline_id, specline.id)

          #if previous action was 'delete'
          if @check_new_match_previous.event == 'deleted'
            #if a previous delete change record matches do not create 'new' change record            
            #delete change record, as this line has no longer been deleted, but re-created      
          end
          
          if @check_new_match_previous.event == 'changed'
            #if previous action was 'change'
            #create 'new' change record for current specline with id of old change
            previous_changed_specline = Specline.where(:id => @check_new_match_previous.specline_id).first

            new_new_rec = Alteration.create( 
                                        :clause_add_delete => @clause_add_delete,
                                        :event => 'new',
                                        :revision_id => revision.id,
                                        :project_id => @check_new_match_previous.project_id,
                                        :clause_id => @check_new_match_previous.clause_id,
                                        :specline_id => @check_new_match_previous.specline_id,
                                        :linetype_id => @check_new_match_previous.linetype_id,
                                        :txt3_id => previous_changed_specline.txt3_id,
                                        :txt4_id => previous_changed_specline.txt4_id,
                                        :txt5_id => previous_changed_specline.txt5_id,
                                        :txt6_id => previous_changed_specline.txt6_id,
                                        :identity_id => previous_changed_specline.identity_id,
                                        :perform_id => previous_changed_specline.perform_id,
                                        :user_id => current_user.id)
          end
          @check_new_match_previous.destroy          
      end   
     end
   end
  end


  def record_change(specline)

    #changes can only be applied to line
    #information used when reporting changes and upon reinstatement 
    clause_add_delete = 1
    
    #get current revision for project     
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    if revision
      #set update hash of specline data for creating new change records
      specline_hash(specline, revision)
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'  

      #check if any changes already made for selected specline in current revision
      #check by rev_id, txts and linetype as 'changed' line may match an existing line or previous change record
      #private method in application controller
      specline_current_text_match_check(specline, revision)
      if @check_new_match_previous.blank?
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_change_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_change_record.blank?          
          #if no previous changes for specline create new record for line 
          new_new_rec = Alteration.create(@specline_hash.merge(
                                          :specline_id => specline.id,
                                          :clause_add_delete => @clause_add_delete,
                                          :event => 'changed'))     
        else
          #if previous action was 'new'
          if existing_change_record.event == 'new'
                existing_change_record.update(:txt3_id => specline.txt3_id,               
                                              :txt4_id => specline.txt4_id,
                                              :txt5_id => specline.txt5_id,
                                              :txt6_id => specline.txt6_id,
                                              :identity_id => specline.identity_id,
                                              :perform_id => specline.perform_id,
                                              :linetype_id => specline.linetype_id,
                                              :user_id => current_user.id)                    
          end
          #if existing_change_record exists then do nothing because original chang record still valid         
        end
      else  
          #if previous action was 'delete'
          if @check_new_match_previous.event == 'deleted'
            
            previous_changes_for_specline = Alteration.where(:specline_id => specline.id).first
#update specline_id of all previous changes for existing change record specline with specline of new line
update_specline_id_prior_changes(@check_new_match_previous.specline_id, specline.id)

            if previous_changes_for_specline
              
              if previous_changes_for_specline.event == 'new'
                #delete change record, as this line has no longer been changed, but re-created
                previous_changes_for_specline.destroy      
              end
              
              if previous_changes_for_specline.event == 'changed'            
                previous_changes_for_specline.update(:event => 'deleted',
                                                     :specline_id => @check_new_match_previous.specline_id,
                                                     :user_id => current_user.id)                
              end

            else            
              #create 'deleted' change record for current specline
              new_delete_rec = Alteration.create(@specline_hash.merge(:clause_add_delete => @clause_add_delete,
                                                                     :event => 'deleted',
                                                                     :specline_id => @check_new_match_previous.specline_id))  
              #delete change record, as this line has no longer been changed, but re-created
                          
            end
            #delete change record, as this line has no longer been changed, but re-created
            @check_new_match_previous.destroy            
          end          
          #if previous action was 'new' then update content of change record
          if @check_new_match_previous.event == 'new'
            previous_changes_for_specline = Alteration.where(:specline_id => specline.id).first
            if previous_changes_for_specline      
              previous_changes_for_specline.update(:txt3_id => specline.txt3_id,               
                                              :txt4_id => specline.txt4_id,
                                              :txt5_id => specline.txt5_id,
                                              :txt6_id => specline.txt6_id,
                                              :identity_id => specline.identity_id,
                                              :perform_id => specline.perform_id,
                                              :linetype_id => specline.linetype_id,
                                              :user_id => current_user.id)                                    
            else                 
#what happens here?         
            end
          end          
          #if previous action was 'changed' then line will have changed back to original
          if @check_new_match_previous.event == 'changed'              
            #double check is same specline as recorded change
            #this should be called when a prevsiously changed record is changed back to its original status
            if @check_new_match_previous.specline_id != @specline.id
#update specline_id of all previous changes for existing change record specline with specline of new changed line
update_specline_id_prior_changes(@check_new_match_previous.specline_id, @specline.id)
              previous_changes_for_specline = Alteration.where(:specline_id => @specline.id).first
              
              if previous_changes_for_specline.blank?            
                #create 'deleted' change record for current specline
                @specline = Specline.find(params[:id])
                previous_changes_for_specline = Alteration.create(@specline_hash.merge(:clause_add_delete => @clause_add_delete,
                                                                     :event => 'changed',
                                                                     :specline_id => @check_new_match_previous.specline_id)) 
              else
                
                #if current change line change record event = changed 
                if previous_changes_for_specline.event == 'changed'
                  #update change record of selected line to reflect               
                  previous_changes_for_specline.update(:specline_id => @check_new_match_previous.specline_id,               
                                                       :user_id => current_user.id)                
                end
                
                #if current change line change record event = new  
                if previous_changes_for_specline.event == 'new'           
                  current_matched_specline = Specline.where(:id => @check_new_match_previous.specline_id).first              
                  #update change record of selected line to reflect               
                  previous_changes_for_specline.update(:specline_id => @check_new_match_previous.specline_id,
                                                        :txt3_id => current_matched_specline.txt3_id,               
                                                        :txt4_id => current_matched_specline.txt4_id,
                                                        :txt5_id => current_matched_specline.txt5_id,
                                                        :txt6_id => current_matched_specline.txt6_id,
                                                        :identity_id => current_matched_specline.identity_id,
                                                        :perform_id => current_matched_specline.perform_id,
                                                        :linetype_id => current_matched_specline.linetype_id,
                                                        :user_id => current_user.id)                                 
                end
              end              
              #update specline_id of all previous changes for selected change record specline with specline of matched change line
              update_specline_id_prior_changes(previous_changes_for_specline.specline_id, @check_new_match_previous.specline_id)                               
            end
            @check_new_match_previous.destroy          
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
      previous_line = Specline.where("project_id = ? AND clause_id = ? AND clause_line = ?", specline.project_id, specline.clause_id, previous_clauseline).last
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




    def specline_current_text_match_check(specline_update, revision)

      specline_hash = {}      
      linetype = Linetype.where(:id => specline_update.linetype_id).first
      
      if linetype[:txt3] == true     
        specline_hash['txt3s.text'] = specline_update.txt3.text
      end
      if linetype[:txt4] == true     
        specline_hash['txt4s.text'] = specline_update.txt4.text
      end
      if linetype[:txt5] == true     
        specline_hash['txt5s.text'] = specline_update.txt5.text
      end
      if linetype[:txt6] == true     
        specline_hash['txt6s.text'] = specline_update.txt6.text
      end
      if linetype[:identity] == true     
        specline_hash['identities.id'] = specline_update.identity.id
      end
      if linetype[:perform] == true     
        specline_hash['performs.id'] = specline_update.perform.id
      end            
      specline_hash[:revision_id] = revision.id
      specline_hash[:project_id] = specline_update.project_id
      specline_hash[:clause_id] = specline_update.clause_id
      specline_hash[:linetype_id] = specline_update.linetype_id 

      @check_new_match_previous = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(:specline_id => specline_update.id).first

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
