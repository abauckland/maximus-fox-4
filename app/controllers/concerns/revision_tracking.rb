module RevisionTracking
  extend ActiveSupport::Concern


  def update_clause_alterations(clause, project, revision, event_type)
    previous_alterations = Alteration.where(:event => 'deleted', :clause_add_delete => 1, :project_id => project.id, :clause_id => clause.id, :revision_id => revision.id)
    previous_alterations.each do |alteration|
      alteration.update(:clause_add_delete => event_type)
    end
  end


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


end