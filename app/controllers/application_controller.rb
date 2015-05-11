class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
#  helper_method :current_user 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  add_flash_types :custom
   
  layout :layout_by_resource

  #root to admin index page after successfull sign in
  def after_sign_in_path_for(resource)
    projects_path
  end



 protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :role, :company_id, :check_field, :company_attributes => [:name, :read_term]) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :current_password, :role, :company_id, :company_attributes => [:name]) }
  end


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

      if current_rev_number == 0 #revision rev == NULL
        @current_revision_rev = "n/a"
      elsif current_rev_number == 1 #revision rev == '-'
        @current_revision_rev = "-"
      else
        revision_rev_array = revisions.collect{|i| i.rev}.sort
        last_revs = revision_rev_array.pop(2)
        if last_rev_check.blank?              
          @current_revision_rev = last_revs.first.capitalize
        else
          @current_revision_rev = last_revs.last.capitalize
        end
      end
    else
      @current_revision_rev = revisions.last.rev.capitalize
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
    revision = Revision.where(:project_id => specline.project_id).where.not(:rev => nil).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft)
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_record.blank?
          #define if change action applied to line, clause or section
          #information used when reporting changes and upon reinstatement
          set_event_type(event_type)
          #set update hash of specline data for creating new change records
          #if no previous changes for specline create delete record for line
#tested - correct 1
          create_alteration_record(specline, specline.id, 'deleted', @event_group, revision)
        else
          #where previous 'new' and 'change' events have been reorded
          #'delete' events not checked as none will exist for selected line (you cannot select a line that has already been deleted)
          #if a change has been previously made to selected specline then...
          #if previous change event was creation of new specline then destory change record
#tested - correct 1
          existing_record.destroy if existing_record.event == 'new'          
          #if previous change was for change to specline then amend action to 'delete' from 'change'
#tested - correct 1
          existing_record.update(:event => 'deleted', :user_id => current_user.id) if existing_record.event == 'changed'
        end
      end
    end
  end


  def record_new(specline, event_type)
    #get current revision for project
    revision = Revision.where(:project_id => specline.project_id).where.not(:rev => nil).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft)
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'
        #define if change action applied to line, clause or section
        #information used when reporting changes and upon reinstatement
        set_event_type(event_type)
        #check if any changes already made for selected specline in current revision
        #check by rev_id, txts and linetype as 'new' line may match an existing line or previous change record
        #private method in application controller
        match_previous(specline, revision)
        if @previous.blank?
#tested - correct 1
            #if no previous changes for specline create new record for line
            create_alteration_record(specline, specline.id, 'new', @event_group, revision)
        else
#diffcult to test - new line is copy of existing, for situation to occur - must have been duplicat in original template?????
            #update specline_id of all precious changes for existing change record specline with specline of new line
            update_specline_id_prior_changes(@previous.specline_id, specline.id)
            #if previous action was 'delete'do not create 'new' change record
            #delete change record, as this line has no longer been deleted, but re-created

            #if previous action was 'change'
            #create 'new' change record for current specline with id of old change
            create_alteration_record(specline, @previous.specline_id, 'new', @event_group, revision) if @previous.event == 'changed'
            @previous.destroy
        end
        #'delete' event not relevant because a line that has been previously deleted cannot be subsequently altered or re-created
      end
    end
  end


  def record_change(old_specline, new_specline)

    #changes can only be applied to line
    #information used when reporting alterations and upon reinstatement
    @event_group = 1

    #get current revision for project
    revision = Revision.where(:project_id => old_specline.project_id).where.not(:rev => nil).order('created_at').last
    #check revision record exists - so next line does not throw error
    if revision
      #do not record alteration if project has not been prevsiously issued (not in draft) 
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'
        #check if any alterations already made to selected specline in current revision
        #check by rev_id, txts and linetype: NEW content may match an existing line or previous alteration record
        #private method in application controller

#if line has not been changed before and...

    #if new_specline content equals content of existing 'delete' record
        #update ids of existing 'delete record' to match new_specline        
        #add 'delete' record for old_specline using existing 'delete record' id and info from old_specline
        #delete existing 'delete record'

    #if new_specline content equals content of existing 'changed' record - not for same specline        
        #delete existing 'change record'
        #create 'changed' alteration record using existing 'change record info with id of old_specline

    #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)
        #create 'changed' alteration record using old_specline info

    #no existing record matches
        #create 'changed' alteration record using old_specline info


#if line has been changed before and action was 'new'

    #if new_specline content equals content of existing 'delete' record
        #delete current new for old_specline
        #delete existing 'delete' record
    
    #if new_specline content equals content of existing 'changed' record - not for same specline
        #delete existing 'change record'
        #update info in existing 'new' record with using existing 'change' record info for other line    

    #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)
        #update info in existing 'new' record with new_specline
    
    #no existing record matches
        #update info in existing 'new' record with new_specline


#if line has been changed before and action was 'changed' then....

    #if new_specline content equals content of existing 'delete' record
        #update ids of existing 'delete record' to match new_specline        
        #add 'delete' record for old_specline using existing 'delete record' id and info from old_specline
        #delete existing 'delete record'

    #if new_specline content equals content of existing 'changed' record - not for same specline
        #delete existing 'change record'
        #create 'changed' alteration record using existing 'change' record info with id of old_specline

    #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)
        #do nothing

    #no existing record matches
        #do nothing

#if line has not been changed before and...
        alterations_for_specline = Alteration.where(:specline_id => new_specline.id, :revision_id => revision.id).first
        #deleted records not applicable as these cannot be changed when they no longer exist
        if alterations_for_specline.blank?

            match_previous(new_specline, revision)
            if !@previous.blank?

              #if new_specline content equals content of existing 'delete' record
              if @previous.event == 'deleted'
#tested - correct 1
                #update ids of existing 'delete record' to match new_specline
                update_specline_id_prior_changes(@previous.specline_id, new_specline.id)
                #add 'delete' record for old_specline using existing 'delete record' id and info from old_specline
                #(content, id, action, event_group, revision)
                create_alteration_record(old_specline, @previous.specline_id, 'deleted', @event_group, revision)
                #delete existing 'delete record'
                @previous.destroy

              #if new_specline content equals content of existing 'changed' record - not for same specline
              elsif @previous.event == 'changed'
#tested - correct 1
                #create 'changed' record using existing 'change record info with id of old_specline
                create_alteration_record(old_specline, @previous.specline_id, 'changed', @event_group, revision)
                #delete existing 'change record'
                @previous.destroy
            
              #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)              
              else
#diffcult to test - new line is copy of existing, for situation to occur - must have been duplicat in original template?????
                #create 'changed' alteration record using old_specline info
                create_alteration_record(old_specline, new_specline.id, 'changed', @event_group, revision)
              end
#tested - correct 1
            else
              #no existing record matches
              #create 'changed' alteration record using old_specline info
              create_alteration_record(old_specline, new_specline.id, 'changed', @event_group, revision)
            end

        else
          #if line has been changed before and action was 'new'
          if alterations_for_specline.event == 'new'

            match_previous(new_specline, revision)
            if !@previous.blank?
            
              #if new_specline content equals content of existing 'delete' record
              if @previous.event == 'deleted'
#tested - correct 1
                #update ids of existing 'delete record' to match new_specline
                update_specline_id_prior_changes(@previous.specline_id, new_specline.id)
                #delete current new for old_specline
                alterations_for_specline.destroy
                #delete existing 'delete record'
                @previous.destroy
#tested - correct 1
              #if new_specline content equals content of existing 'changed' record - not for same specline
              elsif @previous.event == 'changed'
                #update info in existing 'new' record with using existing 'change' record info for other line                
                #get line info for new text of previous change
                previous_new = Specline.where(:id => @previous.specline_id).first                
                update_alteration_record(previous_new, alterations_for_specline.id)
                #delete existing 'change record'
                @previous.destroy
  
              #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)
              else
#diffcult to test - new line is copy of existing, for situation to occur - must have been duplicat in original template?????                
                #update info in existing 'new' record with new_specline
                update_alteration_record(new_specline, @previous.specline_id)
              end
            #or if no existing record matches
            else
#tested - correct 1
               #update info in existing 'new' record with new_specline
               update_alteration_record(new_specline, alterations_for_specline.id)
            end
          end

          #if line has been changed before and action was 'changed' then....
          if alterations_for_specline.event == 'changed'

            match_previous(new_specline, revision)
            if !@previous.blank?
#tested - correct 1
              #if new_specline content equals content of existing 'delete' record
              if @previous.event == 'deleted'
                #update ids of existing change record so that specline id points to text of previous change specline, update all ids
                update_specline_id_prior_changes(alterations_for_specline.id, @previous.specline_id)
                #update ids of existing 'delete record' to match new_specline
                update_specline_id_prior_changes(@previous.specline_id, new_specline.id)

                alterations_for_specline.update(:event => 'deleted')
                #delete existing 'delete record'
                @previous.destroy
#tested - correct 1 
              #if new_specline content equals content of existing 'changed' record - not for same specline
              elsif @previous.event == 'changed'
                #update ids of existing change record so that specline id points to text of previous change specline, update all ids
                update_specline_id_prior_changes(alterations_for_specline.id, @previous.specline_id)
                #delete existing 'change record'
                @previous.destroy

              else
#diffcult to test - new line is copy of existing, for situation to occur - must have been duplicat in original template?????
                #if new_specline content equals content of existing 'new' record - make change based on same specline only (ignor existing new record)
                  #do nothing
              end
            else
#tested - correct 1
              #no existing record matches
                #do nothing
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
 
#    def permission_denied
#      session[:user_id] = nil  
#      redirect_to home_path 
#    end
  
#    def current_user  
#      @current_user ||= User.find(session[:user_id]) if session[:user_id]  
#    end
  
#    def authenticate
      #@current_user ||= User.find(session[:user_id]) if session[:user_id]
      #if @current_user.role == 'user'
      #   redirect_to log_out_path
      #end    
#      redirect_to log_out_path unless current_user
#    end
  
#    def authenticate_owner
#      redirect_to log_out_path unless current_user.role == "owner"
#    end

   
    def match_previous(specline, revision)
        @previous = Alteration.where(
                              :txt3_id => specline.txt3_id,
                              :txt4_id => specline.txt4_id,
                              :txt5_id => specline.txt5_id,
                              :txt6_id => specline.txt6_id,
                              :identity_id => specline.identity_id,
                              :perform_id => specline.perform_id,
                              :revision_id => revision.id,
                              :project_id => specline.project_id,
                              :clause_id => specline.clause_id,
                              :linetype_id => specline.linetype_id
                              ).first                              
    end
  
    #update specline_id of all previous changes to the same line
    def update_specline_id_prior_changes(previous_id, new_id)        
      prior_changes = Alteration.where(:specline_id => previous_id)
      prior_changes.each do |change|
        change.update(:specline_id => new_id)
      end  
    end

    def create_alteration_record(content, line_id, event, event_group, revision)       
       new_alteration_record = Alteration.create({:specline_id => line_id,
                                                  :project_id => content.project_id,
                                                  :clause_id => content.clause_id,                        
                                                  :txt3_id => content.txt3_id,               
                                                  :txt4_id => content.txt4_id,
                                                  :txt5_id => content.txt5_id,
                                                  :txt6_id => content.txt6_id,
                                                  :identity_id => content.identity_id,
                                                  :perform_id => content.perform_id,
                                                  :linetype_id => content.linetype_id,
                                                  :revision_id => revision.id,
                                                  :user_id => current_user.id,
                                                  :clause_add_delete => event_group,
                                                  :event => event,
                                                  :print_change => 1})  
     end

     def update_alteration_record(content, line_id)
       
       alteration = Alteration.where(:id => line_id).first
       
       updated_alteration_record = alteration.update({:txt3_id => content.txt3_id,               
                                                      :txt4_id => content.txt4_id,
                                                      :txt5_id => content.txt5_id,
                                                      :txt6_id => content.txt6_id,
                                                      :identity_id => content.identity_id,
                                                      :perform_id => content.perform_id,
                                                      :user_id => current_user.id,})  
     end

      def set_event_type(event_type) 
          if event_type.blank?
             @event_group = 1
          else
             @event_group = event_type
          end
          return @event_group
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


#    def old_match_previous_alterations(specline, revision)      
#      specline_find_hash(specline, revision)      
#      @match_old_line_content = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(@specline_match_hash).where.not(:event => ['changed', 'deleted']).first
#    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :role, :check_field, :company_id, :company_attributes => [:name, :read_term]) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :surname, :email, :password, :password_confirmation, :current_password, :role, :company_id, :company_attributes => [:name]) }
  end

  def layout_by_resource
    if controller_name == 'sessions' && action_name == 'new'
      'devise'
    elsif  controller_name == 'registrations' && action_name == 'new'
      'devise'
    elsif  controller_name == 'registrations' && action_name == 'create'
      'devise'
    elsif  controller_name == 'passwords' && action_name == 'new'
      'devise'
    elsif  controller_name == 'passwords' && action_name == 'edit'
      'devise'
    elsif  controller_name == 'passwords' && action_name == 'create'
      'devise'
    elsif  controller_name == 'unlocks' #&& action_name == 'new'
      'devise'
    else
      'projects'
    end
  end

  
end
