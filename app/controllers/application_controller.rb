class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  include Pundit
  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied  
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied


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


  def update_clause_alterations(clause, project, revision, event_type)
    previous_alterations = Alteration.where(:event => 'deleted', :clause_add_delete => 1, :project_id => project.id, :clause_id => clause.id, :revision_id => revision.id)
    previous_alterations.each do |alteration|
      alteration.update(:clause_add_delete => event_type)
    end
  end

# def set_event_type(line, revision)
  #if new line added to new clause/section
    #check event type for line
    #do changes exist for same clause
    #previous_line_alteration = Alteration.where(:project_id => line.project_id, :clause_id => line.clause_id, :revision_id => revision.id).first
    #if !previous_line_alterations.blank?
      #event_type = previous_line_alteration.event_type
    #else
      #event_type = 1
    #end
  #end

  #if line deleted from new clause/section
  #if change to line of new clause/section


  def record_delete(deleted_line, event_type)
    #get current revision for project
    revision = Revision.where(:project_id => deleted_line.project_id).where.not(:rev => nil).order('created_at').last
    if revision
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'

set_event_type(deleted_line, revision, event_type)

        existing_record = Alteration.where(:specline_id => deleted_line.id, :revision_id => revision.id).first
        if existing_record.blank?
  
          old_matched_line = Alteration.match_line(deleted_line, revision).first
          if old_matched_line.blank?

# if new_line matches and has chnage alteration associated with it


            new_matched_change_action(deleted_line, revision, 'changed')
            if @new_matched_line.blank?
              create_alteration_record(deleted_line, deleted_line.id, 'deleted', @event_type, revision)
            else

              old_changed_line = Alteration.where(:specline_id => @new_matched_line.id, :revision_id => revision.id).first

              update_id_prior_changes(deleted_line.id, revision, old_changed_line.specline_id)
              update_id_prior_changes(old_changed_line.specline_id, revision, deleted_line.id)

              new_delete_hash = old_changed_line.dup
              new_delete_hash[:id] = new_delete_hash.specline_id

              old_changed_line.destroy

              record_delete(new_delete_hash, @event_type)

            end

          else
            if old_matched_line.event == 'new'
              update_id_prior_changes(deleted_line.id, revision, old_matched_line.specline_id)
              old_matched_line.destroy 
            else
              create_alteration_record(deleted_line, deleted_line.id, 'deleted', @event_type, revision)
            end
          end


        else
          if existing_record.event == 'new'
            existing_record.destroy
          end

          if existing_record.event == 'changed'

            new_delete_hash = existing_record.dup
            new_delete_hash[:id] = new_delete_hash.specline_id

            existing_record.destroy
            record_delete(new_delete_hash, @event_type)
          end
        end

      end
    end
  end


  def record_new(new_line, event_type)
    #get current revision for project
    revision = Revision.where(:project_id => new_line.project_id).where.not(:rev => nil).order('created_at').last
    if revision
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'

set_event_type(new_line, revision, event_type)

        old_matched_line = Alteration.match_line(new_line, revision).where.not(:event => 'new').first
        if old_matched_line.blank?
          create_alteration_record(new_line, new_line.id, 'new', @event_type, revision)
        else
          if old_matched_line.event == 'changed'
            new_matched_line = Specline.find(old_matched_line.specline_id)

            update_id_prior_changes(old_matched_line.id, revision, new_line.id)
            old_matched_line.destroy

            record_new(new_matched_line, event_type)
          else
            update_id_prior_changes(old_matched_line.id, revision, new_line.id)
            old_matched_line.destroy
          end
        end

      end
    end
  end


  def record_change(old_line, new_line)

    revision = Revision.where(:project_id => old_line.project_id).where.not(:rev => nil).order('created_at').last
    if revision
      if revision.rev.to_s == '-' || revision.rev.to_s >= 'a'

set_event_type(new_line, revision, event_type)
  
        existing_record = Alteration.where(:specline_id => new_line.id, :revision_id => revision.id).first
        if existing_record.blank?

          old_matched_line = Alteration.match_line(old_line, revision).where.not(:event => 'changed').first
          if !old_matched_line.blank?

            if old_matched_line.event == 'new'
              update_id_prior_changes(new_line.id, revision, old_matched_line.specline_id)
              old_matched_line.destroy
              record_new(new_line, event_type)
            else #old_matched_line.event = 'deleted'
              create_alteration_record(old_line, new_line.id, 'changed', @event_type, revision)
            end

          else

            new_matched_line = Alteration.match_line(new_line, revision).where.not(:event => 'changed').first
            if !new_matched_line.blank?

              if new_matched_line.event == 'deleted'
                update_id_prior_changes(new_line.id, revision, new_matched_line.specline_id)
                update_id_prior_changes(new_matched_line.specline_id, revision, new_line.id)

                new_matched_line.destroy

                old_line[:id] = new_matched_line.specline_id
                record_delete(old_line, event_type)

              else #new_matched_line.event = 'new'
                create_alteration_record(old_line, new_line.id, 'changed', @event_type, revision)
              end

            else

              old_matched_line = Alteration.match_line(new_line, revision).where(:event => 'changed').first
              new_matched_change_action(old_line, revision, 'changed')

              if !old_matched_line.blank?
                if !@new_matched_line.blank?
                  update_id_prior_changes(new_line.id, revision, @new_matched_line.id)
                  update_id_prior_changes(@new_matched_line.id, revision, new_line.id)

                  old_matched_line.destroy
                else
                  update_id_prior_changes(new_line.id, revision, old_matched_line.id)
                  update_id_prior_changes(old_matched_line.id, revision, new_line.id)

                  new_match_line_change = Specline.find(old_matched_line.specline_id)

                  old_matched_line.destroy

                  record_change(old_line, new_match_line_change)
                end
              else
                if !@new_matched_line.blank?
                  update_id_prior_changes(new_line.id, revision, @new_matched_line.id)
                  update_id_prior_changes(@new_matched_line.id, revision, new_line.id)



#                  old_matched_line.destroy
old_match_line_change = Alteration.where(:specline_id => @new_matched_line.id, :revision_id => revision.id, :event => 'changed').first


                  original_line_hash = old_match_line_change.dup
                  original_line_hash[:id] = @new_matched_line.id

old_match_line_change.destroy

                  record_change(original_line_hash, new_line)
                else
                  create_alteration_record(old_line, new_line.id, 'changed', @event_type, revision)
                end
              end

            end
          end

        else
          if existing_record.event == 'new'
            existing_record.destroy
            record_new(new_line, @event_type)
          end

          if existing_record.event == 'changed'

            original_line_hash = existing_record.dup
            original_line_hash[:id] = original_line_hash.specline_id

            existing_record.destroy
            record_change(original_line_hash, new_line) if original_not_same_as_new(original_line_hash, new_line)

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
      head 403
    end


    def new_matched_change_action(current_line, revision, action)
      @new_matched_line = Specline.joins(:alterations).where(
                              :txt3_id => current_line.txt3_id,
                              :txt4_id => current_line.txt4_id,
                              :txt5_id => current_line.txt5_id,
                              :txt6_id => current_line.txt6_id,
                              :identity_id => current_line.identity_id,
                              :perform_id => current_line.perform_id,
                              :project_id => current_line.project_id,
                              :clause_id => current_line.clause_id,
                              :linetype_id => current_line.linetype_id,
                              'alterations.revision_id' => revision.id,
                              'alterations.event' => action
                              ).first
    end


    def update_id_prior_changes(line_id, revision, new_id)
      prior_changes = Alteration.where(:specline_id => line_id).where.not(:revision_id => revision.id)
      prior_changes.each do |change|
        change.update(:specline_id => new_id)
      end
    end


    def create_alteration_record(content, line_id, event, event_group, revision)
       new_alteration_record = Alteration.create(:specline_id => line_id,
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
                                                 :print_change => 1
                                                 )
     end


      def original_not_same_as_new(existing, line)
  
        values_from_existing = [
          existing.txt3_id,
          existing.txt4_id,
          existing.txt5_id,
          existing.txt6_id,
          existing.identity_id,
          existing.perform_id,
          existing.linetype_id
          ]
  
        values_from_line = [
          line.txt3_id,
          line.txt4_id,
          line.txt5_id,
          line.txt6_id,
          line.identity_id,
          line.perform_id,
          line.linetype_id
          ]
  
        if values_from_existing == values_from_line
          false
        else
          true
        end
  
      end


      def set_event_type(line, revision, event_type)
        #if new line added to new clause/section
        #check event type for line
        #do changes exist for same clause
        previous_line_alteration = Alteration.where(:project_id => line.project_id, :clause_id => line.clause_id, :revision_id => revision.id).first
        if !previous_line_alteration.blank?
          @event_type = previous_line_alteration.clause_add_delete
        else
          @event_type = event_type
        end
      end


#    def old_match_previous_alterations(specline, revision)      
#      specline_find_hash(specline, revision)      
#      @match_old_line_content = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(@specline_match_hash).where.not(:event => ['changed', 'deleted']).first
#    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :surname, :email, :password, :password_confirmation, :role, :company_id, :check_field, :state, :company_attributes => [:name, :read_term]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :surname, :email, :password, :password_confirmation, :current_password, :role, :state, :company_id, :company_attributes => [:name]])
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
