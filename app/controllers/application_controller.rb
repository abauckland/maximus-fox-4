class ApplicationController < ActionController::Base
  include Pundit
  
  helper :all # include all helpers, all the time
  helper_method :current_user 
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied  
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied


 protected 

  def clean_text(value)
    @value = value 
    @value.strip
    @value = @value.gsub(/\n/,"")
    @value.chomp
    @value.chomp   
    while [",", ";", "!", "?"].include?(value.last)
    @value.chop!
    end
  end
  
#project action => manage_subsections  
  def current_revision_render(project)

    project_revisions = Revision.where('project_id = ?', project.id).order('created_at')         
    last_rev_check = Alteration.where(:project_id => project.id, :revision_id => project_revision_ids.last).first
    if last_rev_check.blank?
      #remove last revision reference from id array if no changes recorded for that revision
      project_revisions.pop
    end  
    
    if project_revisions.last.rev == '-'
      @current_revision_rev = '-'
    else    
      @current_revision_rev = project_revisions.last.rev.capitalize
    end
    
    if project_revisions.last.rev.nil?
      @current_revision_rev = 'n/a'
    end
    
  end  


  def check_project_status_change(project, revision)
    previous_statuses = Revision.where(:project_id => project.id).pluck(:project_status)
    @previous_revision_project_status = previous_statuses[previous_statuses.length - 2]                        
    if revision.project_status != @previous_revision_project_status
      @project_status_changed = true
    end
  end


  def update_subsequent_specline_clause_line_ref(subsequent_specline_lines, action_type, selected_specline)
    
    if subsequent_specline_lines   
     subsequent_specline_lines.each_with_index do |subsequent_specline, i|
      if action_type == 'new'
        subsequent_specline.update_attributes(:clause_line => selected_specline.clause_line + 2 + i)
      end
      if action_type =='delete'
        subsequent_specline.update_attributes(:clause_line => selected_specline.clause_line + i)
      end
     end
    end    
  end


  def record_delete(specline, clause_change_record)
      
    #get current revision for project 
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_record.blank?
          #define if change action applied to line, clause or section
          #information used when reporting changes and upon reinstatement
          if clause_change_record.blank?
             clause_add_delete = 1
          else
             clause_add_delete = clause_change_record
          end
          #if no previous changes for specline create delete record for line                     
          new_delete_rec = Alteration.create(specline.attributes.merge(:clause_add_delete => clause_add_delete,
                                                                     :event => 'deleted',
                                                                     :revision_id => revision.id,
                                                                     :user_id => current_user.id )) 
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


  def record_new(specline, clause_change_record)
    #define if change action applied to line, clause or section
    #information used when reporting changes and upon reinstatement     
    if clause_change_record.blank?
      clause_add_delete = 1
    else
      clause_add_delete = clause_change_record
    end
    
    #get current revision for project     
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'                       
      #check if any changes already made for selected specline in current revision
      #check by rev_id, txts and linetype as 'new' line may match an existing line or previous change record
      #private method in application controller
      specline_current_text_match_check(specline, revision)
      if @check_new_match_previous.blank?
                   
          #if no previous changes for specline create new record for line 
          new_new_rec = Alteration.create(specline.attributes.merge(:clause_add_delete => clause_add_delete,
                                                                     :event => 'new',
                                                                     :revision_id => revision.id,
                                                                     :user_id => current_user.id )) 
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

            new_new_rec = Change.create(:clause_add_delete => clause_add_delete,
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


  def record_change(specline, specline_update)
        
    #changes can only be applied to line
    #information used when reporting changes and upon reinstatement 
    clause_add_delete = 1
    
    #get current revision for project     
    revision = Revision.where(:project_id => specline.project_id).order('created_at').last
    if revision
      #do not record change if project has not been prevsioulsy issued (not in draft) 
      if revision.rev.to_s >= 'a'  

      #check if any changes already made for selected specline in current revision
      #check by rev_id, txts and linetype as 'changed' line may match an existing line or previous change record
      #private method in application controller
      specline_current_text_match_check(specline_update, revision)
      if @check_new_match_previous.blank?
        #check if any changes already made for selected specline in current revision
        #check by specline_id and rev_id only as delete action does not create/change a line whereby it may match an existing line or previous change
        existing_change_record = Alteration.where(:specline_id => specline.id, :revision_id => revision.id).first
        if existing_change_record.blank?          
          #if no previous changes for specline create new record for line 
          new_new_rec = Alteration.create(specline.attributes.merge(:clause_add_delete => clause_add_delete,
                                                                     :event => 'changed',
                                                                     :revision_id => revision.id,
                                                                     :user_id => current_user.id ))
        else
          #if previous action was 'new'
          if existing_change_record.event == 'new'
                existing_change_record.update(:txt3_id => specline_update.txt3_id,               
                                              :txt4_id => specline_update.txt4_id,
                                              :txt5_id => specline_update.txt5_id,
                                              :txt6_id => specline_update.txt6_id,
                                              :identity_id => specline_update.identity_id,
                                              :perform_id => specline_update.perform_id,
                                              :linetype_id => specline_update.linetype_id,
                                              :user_id => current_user.id)                    
          end
          #if existing_change_record exists then do nothing because original chang record still valid         
        end
      else  
          #if previous action was 'delete'
          if @check_new_match_previous.event == 'deleted'
            
            previous_changes_for_specline = Alteration.where(:specline_id => specline_update.id).first
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
              new_delete_rec = Alteration.create(specline.attributes.merge(:clause_add_delete => clause_add_delete,
                                                                     :event => 'deleted',
                                                                     :revision_id => revision.id,
                                                                     :specline_id => @check_new_match_previous.specline_id,
                                                                     :user_id => current_user.id ))  
              #delete change record, as this line has no longer been changed, but re-created
                          
            end
            #delete change record, as this line has no longer been changed, but re-created
            @check_new_match_previous.destroy            
          end          
          #if previous action was 'new' then update content of change record
          if @check_new_match_previous.event == 'new'
            previous_changes_for_specline = Alteration.where(:specline_id => specline_update.id).first
            if previous_changes_for_specline      
              previous_changes_for_specline.update(:txt3_id => specline_update.txt3_id,               
                                              :txt4_id => specline_update.txt4_id,
                                              :txt5_id => specline_update.txt5_id,
                                              :txt6_id => specline_update.txt6_id,
                                              :identity_id => specline_update.identity_id,
                                              :perform_id => specline_update.perform_id,
                                              :linetype_id => specline_update.linetype_id,
                                              :user_id => current_user.id)                                    
            else                 
#what happens here?         
            end
          end          
          #if previous action was 'changed' then line will have changed back to original
          if @check_new_match_previous.event == 'changed'              
            #double check is same specline as recorded change
            #this should be called when a prevsiously changed record is changed back to its original status
            if @check_new_match_previous.specline_id != @specline_update.id
#update specline_id of all previous changes for existing change record specline with specline of new changed line
update_specline_id_prior_changes(@check_new_match_previous.specline_id, @specline.id)
              previous_changes_for_specline = Change.where(:specline_id => @specline_update.id).first
              
              if previous_changes_for_specline.blank?            
                #create 'deleted' change record for current specline
                @specline = Specline.find(params[:id])
                previous_changes_for_specline = Alteration.create(specline.attributes.merge(:clause_add_delete => clause_add_delete,
                                                                     :event => 'changed',
                                                                     :revision_id => revision.id,
                                                                     :specline_id => @check_new_match_previous.specline_id,
                                                                     :user_id => current_user.id )) 
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
    get_previous_specline_line = Specline.where("project_id = ? AND clause_id = ? AND clause_line = ?", specline.project_id, specline.clause_id, previous_clauseline).order("clause_line").last
    check_linetype = Linetype.find(get_previous_specline_line.linetype_id)
      if check_linetype.txt1 == true
        set_txt1_id = get_previous_specline_line.txt1_id
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
      get_previous_specline_line = Specline.where("project_id = ? AND clause_id = ? AND clause_line = ?", specline.project_id, specline.clause_id, previous_clauseline).last
      check_linetype = Linetype.find(get_previous_specline_line.linetype_id)
      if check_linetype.txt1 == true
        specline.txt1_id = get_previous_specline_line.txt1_id + 1
        set_txt1_id = get_previous_specline_line.txt1_id + 1 
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


def update_subsequent_lines(subsequent_clause_lines, set_txt1_id)
  @subsequent_prefixes = []
  subsequent_clause_lines.each_with_index do |next_clause_line, i|

  check_linetype = Linetype.where('id =?', next_clause_line.linetype_id).first
    if check_linetype.txt1 == true
      next_txt1_id = (set_txt1_id + 1 + i)
      next_clause_line.txt1_id = next_txt1_id
      next_clause_line.save      
      next_txt1_text = Txt1.where(:id => next_txt1_id).first
      @subsequent_prefixes[i] = [next_clause_line.id, next_txt1_text.text] 
    else
      break
    end
  end
end



def update_subsequent_lines_last(subsequent_clause_lines, set_txt1_id)
  subsequent_clause_lines.each_with_index do |next_clause_line, i|
  check_linetype = Linetype.where('id =?', next_clause_line.linetype_id).first
    if check_linetype.txt1 == true
      next_clause_line.txt1_id = (set_txt1_id + i)
      next_clause_line.save
    else
      break
    end
  end
end

def update_subsequent_lines_on_move(subsequent_clause_lines, set_txt1_id)
    @subsequent_prefixes = []
  subsequent_clause_lines.each_with_index do |next_clause_line, i|
  check_linetype = Linetype.where('id =?', next_clause_line.linetype_id).first
    if check_linetype.txt1 == true
       next_txt1_id = (set_txt1_id + 1 + i)
      next_clause_line.txt1_id = next_txt1_id
      next_clause_line.save      
      next_txt1_text = Txt1.where(:id => next_txt1_id).first     
      @subsequent_prefixes[i] = [next_clause_line.id, next_txt1_text.text] 
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

  def authentize_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    if @current_user.role == 'user'
       redirect_to log_out_path
    end
  end

  def require_user
    unless current_user
      redirect_to log_out_path
      return false
    end
  end



#user_role(["admin", "owner", "employee"])
#project_role(@project, ["manage", "publish", "write", "read"])

  def authorise_user_view(permissible_roles)
    if permissible_roles.include?(@current_user.role)
      return true
    end      
  end

  def authorise_user_action(permissible_roles)
    if permissible_roles.include?(@current_user.role)
      redirect_to log_out_path
    end      
  end


  def authorise_project_view(project_id, permissible_roles)
    if permissible_roles == "all"
      return true
    else
      project_user = Projectuser.where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles).first    
      if project_user
        return true
      end
    end    
  end

  def authorise_project_action(project_id, permissible_roles)
    if permissible_roles == "all"
      permissible_roles = ["manage", "edit", "write", "read"]
    end
    project_user = Projectuser.where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles).first    
    if project_user.blank?
      redirect_to log_out_path
    end     
  end


  def authorised_subsection_ids(project)
    permitted_subsections = Subsectionuser.joins(:projectusers).where('projectusers.user_id' => @current_user.id, 'projectusers.project_id' => project.id)  
    if permitted_subsections.blank?
      @authorised_subsection_ids = Subsection.joins(:clauseref => [:clause => :specline]
                                       ).where('speclines.project_id' =>project.id
                                       ).group(:id)
   else
     @authorised_subsection_ids = Subsection.joins(:subsectionusers => :projectusers
                                       ).where('projectusers.user_id' => @current_user.id, 'projectusers.project_id' => project.id
                                       ).group('subsectionusers.subsection_id')
    end                                   
  end



  def subsection_action(project_id, subsection_id, permissible_roles)
    permitted_user = Projectuser.joins(:subsectionusers
                               ).where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles
                               ).where.not('subsectionusers.subsection_id' => subsection_id
                               ).first    
    if permitted_user.blank?
       redirect_to log_out_path
    end      
  end

  def authorise_specline_view(permissible_roles)
    if permissible_roles.include?(@current_user.role)
      return true
    end     
  end


  def authorise_specline_action(specline_id, permissible_roles)
    permitted_user = Subsectionuser.where(:user_id => @current_user.id, :project_id => project_id, :role => permissible_roles).first    
    if permitted_user.blank?
       redirect_to log_out_path
    end      
  end




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

      @check_new_match_previous = Alteration.joins(:txt3, :txt4, :txt5, :txt6, :identity, :perform).where(specline_hash).first

  end
  
  #update specline_id of all precious changes for existing change record specline with specline of new line
  def update_specline_id_prior_changes(previous_change_specline_id, new_specline_id)
    
    prior_specline_changes = Alteration.where('specline_id =?', previous_change_specline_id)
    prior_specline_changes.each do |prior_change|
      prior_change.specline_id = new_specline_id
      prior_change.save
    end  
  end


def get_sub_clause_ids(clause_id)

  clause = Clause.where(:id => clause_id).first
  if clause.clauseref.subclause != 0
    @sub_clause_ids = [clause.id]
  else
    if clause.clauseref.clause != 0 
      if clause.clauseref.clause.multiple_of?(10)
        low_ref = clause.clauseref.clause
        high_ref = clause.clauseref.clause + 9
        @sub_clause_ids = Clause.joins(:clauseref
                                ).where('clauserefs.clausetype_id' => clause.clauseref.clausetype_id, 'clauserefs.clause' => [low_ref..high_ref]
                                ).pluck('clauses.id')
      else
        @sub_clause_ids = Clause.joins(:clauseref
                                ).where('clauserefs.clausetype_id' => clause.clauseref.clausetype_id, 'clauserefs.clause' => clause.clauseref.clause
                                ).pluck('clauses.id')
      end
    else
      @sub_clause_ids = Clause.joins(:clauseref
                              ).where('clauserefs.clausetype_id' => clause.clauseref.clausetype_id
                              ).pluck('clauses.id')
    end
  end
end

def possible_products(specline)
    #get product identity pairs in clause which have been completed, not including current line
    product_identity_pairs = Specline.product_identity_pairs(specline)
   
    #get product perform pairs in clause which have been completed, not including current line
    product_perform_pairs = Specline.product_perform_pairs(specline)
    #get cpossible products for line
    #if specline linetype == 10 (identity pair)
    #get possible products for identity and perform pairs
    if product_identity_pairs.empty?
      if product_perform_pairs.empty?
        possible_products = Product.joins(:clauseproducts
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids)  
      else
        possible_products = Product.joins(:clauseproducts, :instances => :charcs
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids, 'charcs.perform_id'=>  product_perform_pairs
                                  ).group('products.id)'
                                  ).having('count(products.id) == product_perform_pairs.count'                                 
                                  )        
      end
    else
      if product_perform_pairs.empty?
        possible_products = Product.joins(:clauseproducts, :descripts
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids, 'descripts.identity_id'=> product_identity_pairs
                                  ).group('products.id)'
                                  ).having('count(products.id) == product_identity_pairs.count'
                                  ) 
      else
        possible_ident_product_ids = Product.joins(:clauseproducts, :descripts
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids, 'descripts.identity_id'=> product_identity_pairs
                                  ).group('products.id)'
                                  ).having('count(products.id) == product_identity_pairs.count'
                                  ).collect{|x | x.id}.uniq        
        possible_products = Product.joins(:clauseproducts, :descripts, :instances => :charcs
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids, 'descripts.identity_id'=> product_identity_pairs, 'product.id'=> possible_ident_product_ids
                                  ).group('products.id)'
                                  ).having('count(products.id) > product_perform_pairs.count'
                                  )     
      end        
    end
    possible_product_ids = possible_products.collect{|x| x.id}.uniq
end
  
end
