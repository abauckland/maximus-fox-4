class SpeclinesController < ApplicationController
  before_action :set_specline



  # GET
  def new_specline
    
    authorize @specline 
     
    #call to protected method in application controller that changes the clause_line ref in any subsequent speclines    
    existing_subsequent_specline_lines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', @specline.clause_id, @specline.project_id, @specline.clause_line).order('clause_line')    
    update_subsequent_specline_clause_line_ref(existing_subsequent_specline_lines, 'new', @specline)
      
    if @specline.clause_line == 0
      case @specline.clausetype_id
        when '1', '6', '7', '8', '10', '11', '12' ;  @linetype_id = 7
        when '2', '3', '4', '5' ;  @linetype_id = 8
      end
    else
      linetype_id = @specline.linetype_id
    end 
    
    #if specline is a product or reference line (linetype 10, 11 or 12) 
    if [10,11].include?(@specline.linetype_id) 
     @new_specline = Specline.new do |n|        
            n.project_id = @specline.project_id 
            n.clause_id = @specline.clause_id 
            n.clause_line = @specline.clause_line + 1
            n.txt1_id = 1
            n.txt2_id = 1
            n.txt3_id = 1
            n.txt4_id = 1
            n.txt5_id = 1
            n.txt6_id = 1
            n.identity_id = 1
            n.perform_id = 1
            n.linetype_id = linetype_id
          end  
     else
      @new_specline = Specline.new(@specline.attributes.merge(:clause_line => @specline.clause_line + 1, :linetype_id => linetype_id))               
     end  
     @new_specline.save 
      
    #if other lines of clause have been deleted in same revision then amended to recorded change event for line
      @current_revision = Revision.where('project_id = ?', @specline.project_id).last
      previous_change_to_clause = Change.where(:project_id => @specline.project_id, :clause_id => @specline.clause_id, :revision_id => @current_revision.id).order('created_at').last
      if !previous_change_to_clause.blank?  
          @clause_change_record = previous_change_to_clause.clause_add_delete      
      end
               
    #call to private method that records addition of line in Changes table
    record_new    
    #change prefixs to clauselines in clause
    txt1_insert_line(@new_specline, @specline, existing_subsequent_specline_lines)
      if !@subsequent_prefixes.blank?
        @subsequent_prefixes.compact
      end
    end
       
    respond_to do |format|
        format.js   { render :new_specline, :layout => false } 
  end
#################################

def move_specline
    
    authorize @specline

    @selected_specline = @specline #obtained in before filter
    

###general stuff
    prefixed_linetypes_array = Linetype.where('txt1 = ?', 1).collect{|i| i.id}

####old location information
#old clause information
    old_limit_ref = @selected_specline.clause_line
    old_clause_line_limit = old_limit_ref - 2 
    previous_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', @selected_specline.clause_id,  @selected_specline.project_id, old_clause_line_limit).order('clause_line')
    previous_specline_id_array = previous_speclines.collect{|i| i.id}
    previous_specline_id_array_length = previous_specline_id_array.length
#old position information
    #@selected_specline
#id of line above old position
    #selected_specline_id_location = previous_specline_id_array.index(@selected_specline.id)
    #old_above_id_location = selected_specline_id_location - 1
    old_above_specline = previous_speclines[0]#old_above_id_location]
#id of line below old position
    #old_below_id_location = selected_specline_id_location + 1
    old_below_specline = previous_speclines[2]#old_below_id_location]


#####old location tidy up
#renumber clause_lines
  if previous_specline_id_array_length > 2
    old_above_clauseline_ref = old_above_specline.clause_line
    last_array_item_ref = previous_specline_id_array_length - 1

    for i in (2..last_array_item_ref) do
      specline_to_change = previous_speclines[i]
      specline_to_change.clause_line = i - 1 + old_above_clauseline_ref 
      specline_to_change.save
    end
  end

#renumber prefixes
#check if line had prefix
if prefixed_linetypes_array.include?(@selected_specline.linetype_id)

          if !prefixed_linetypes_array.include?(old_above_specline.linetype_id)
            set_txt1_id = 0
          else
            set_txt1_id = old_above_specline.txt1_id #- 1
          end
          
          if previous_speclines.length > 2
            subsequent_clause_lines = previous_speclines[2..last_array_item_ref]
            update_subsequent_lines_on_move(subsequent_clause_lines, set_txt1_id)
                  if !@subsequent_prefixes.blank?
                    @previous_prefixes = @subsequent_prefixes.compact
                  end
          end    
else #if did not have prefix then update only if above and below had prefixes
  if prefixed_linetypes_array.include?(old_above_specline.linetype_id)
    if !old_below_specline.blank?
    if prefixed_linetypes_array.include?(old_below_specline.linetype_id)
          set_txt1_id = old_above_specline.txt1_id
          subsequent_clause_lines = previous_speclines[2..last_array_item_ref]
          update_subsequent_lines_on_move(subsequent_clause_lines, set_txt1_id)
           if !@subsequent_prefixes.blank?
                    @previous_prefixes = @subsequent_prefixes.compact
                  end 
    end
    end
  end 
end



####new location information
#new position information
######    
    array_as_string = params[:table_id_array]
    id_array = array_as_string.split(",").map { |s| s.to_s }
   # id_as_string = params[:id]
   # b = a.to_i
    array_location = id_array.index(params[:id])

#id of new above position
if array_location == 0  
    new_above_specline = Specline.where('clause_id = ? AND project_id = ? AND clause_line = ?', @selected_specline.clause_id,  @selected_specline.project_id, 0).first  
else

    new_above_id_location = array_location - 1
    new_above_specline_id = id_array[new_above_id_location]
    new_above_specline = Specline.where(:id => new_above_specline_id).first
end
    @new_above_specline = new_above_specline
    new_limit_ref = new_above_specline.clause_line
    new_above_clauseline_ref = new_above_specline.clause_line
########
   
#new clause information

    new_clause_line_limit = new_limit_ref - 1
    next_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', new_above_specline.clause_id,  new_above_specline.project_id, new_clause_line_limit).order('clause_line')
    next_specline_id_array = next_speclines.collect{|item| item.id}
    next_specline_id_array_length = next_specline_id_array.length
#id of new below position

    new_below_specline = next_speclines[1]

  if !new_below_specline.blank?   
      
  if next_specline_id_array.include?(@selected_specline.id)
    index_of_id = next_specline_id_array.index(@selected_specline.id)
    next_speclines.delete_at(index_of_id)
    last_array_item_ref = next_specline_id_array_length - 2
  else
    last_array_item_ref = next_specline_id_array_length - 1
  end
    
  if next_specline_id_array_length > 1
    for i in (1..last_array_item_ref) do
      specline_to_change = next_speclines[i]
      specline_to_change.clause_line = i + 1 + new_above_clauseline_ref
      specline_to_change.save
    end
  end

end
  #renumber prefixes
#check if moved line had prefix

if prefixed_linetypes_array.include?(@selected_specline.linetype_id)

    if prefixed_linetypes_array.include?(new_above_specline.linetype_id)
     if !new_below_specline.blank? 
      if prefixed_linetypes_array.include?(new_below_specline.linetype_id)
      #if both do
       new_selected_txt1_id = new_above_specline.txt1_id
        selected_specline_new_txt1_id = new_selected_txt1_id + 1
        subsequent_clause_lines = next_speclines[1..last_array_item_ref]
        update_subsequent_lines_on_move(subsequent_clause_lines, selected_specline_new_txt1_id)
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end 
      else
      #if above does but below does not
        new_selected_txt1_id = new_above_specline.txt1_id
        selected_specline_new_txt1_id = new_selected_txt1_id + 1 
      end
     else
        new_selected_txt1_id = new_above_specline.txt1_id
        selected_specline_new_txt1_id = new_selected_txt1_id + 1 
       
     end
    else
     if !new_below_specline.blank? 
      if prefixed_linetypes_array.include?(new_below_specline.linetype_id)
      #if above does not and below does
        selected_specline_new_txt1_id = 1
        subsequent_clause_lines = next_speclines[1..last_array_item_ref]
        update_subsequent_lines_on_move(subsequent_clause_lines, new_above_specline.txt1_id)
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end 
      else
      #if both do not
        selected_specline_new_txt1_id = 1
      end
     else
      #if both do not
      selected_specline_new_txt1_id = 1
     end
    end

else #if did not have prefix then update only if above and below had prefixes

    if prefixed_linetypes_array.include?(new_above_specline.linetype_id) 
     if !new_below_specline.blank? 
      if prefixed_linetypes_array.include?(new_below_specline.linetype_id)
      #if both do
        subsequent_clause_lines = next_speclines[1..next_specline_id_array_length]
        update_subsequent_lines_on_move(subsequent_clause_lines, 0) 
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end      
      end
     end 
    end
    selected_specline_new_txt1_id = 1 
end

#tracking changes

  if new_above_specline.clause_id != old_above_specline.clause_id 
    @new_specline = Specline.create(@selected_specline.attributes.merge(:txt1_id => selected_specline_new_txt1_id, :clause_id => new_above_specline.clause_id, :clause_line => new_above_clauseline_ref + 1))
      @current_revision = Revision.where('project_id = ?', @new_specline.project_id).last
      previous_change_to_clause = Change.where('project_id = ? AND clause_id = ? AND revision_id =?', @new_specline.project_id, @new_specline.clause_id, @current_revision.id).order('created_at').last
      if !previous_change_to_clause.blank?  
        @clause_change_record = previous_change_to_clause.clause_add_delete      
      end
    record_new  
    
    @specline = @selected_specline
    @specline.destroy
    record_delete
      @old_specline_ref = @selected_specline.id
      @updated_specline = Specline.where(:id => @new_specline.id).first
  else
    @old_specline_ref = @selected_specline.id
      @selected_specline.txt1_id = selected_specline_new_txt1_id
      @selected_specline.clause_line = new_above_clauseline_ref + 1
      @selected_specline.save
        @updated_specline = Specline.where(:id => @old_specline_ref).first
  end

    respond_to do |format|
      format.js   { render :move_specline, :layout => false } 
    end

end
  

  
  # GET /speclines/1/edit
  def edit     
    authorize @specline
    #before filter establishes @specline

    #check if products exist for clause
    product_check = Clauseproduct.where(:clause_id => @specline.clause_id).first
    if product_check
      #show linetype option for product data    
      @linetypes = Linetype.joins(:lineclausetypes).where('lineclausetypes.clausetype_id'=> @specline.clause.clauseref.clausetype_id).order('id')
    else
      #do not show linetype option for product data
      @linetypes = Linetype.joins(:lineclausetypes).where('lineclausetypes.clausetype_id'=> @specline.clause.clauseref.clausetype_id).where.not(:id => 10).order('id')
    end
    
    respond_to do |format|
      format.js   { render :edit, :layout => false } 
    end    
              
  end
  
  

  # PUT /projects/update_specline_3/id
  def update_specline_3
    authorize @specline    
    #before filter establishes @specline
    @specline_update = @specline
    #existing_text = @specline.txt3.text
    
    #application controller
    #removes white space and punctuation from end of text
    clean_text(params[:value])
    
    #value = new text
    if @value
      #save new text if exact match does not exist in Txt table
      #get new text info
      txt3_exist = Txt3.where('BINARY text =?', @value).first 
        if txt3_exist.blank?
          new_txt3_text = Txt3.create(:text => @value)
        else
          new_txt3_text = txt3_exist
        end
     
      #check if new text is similar to old text 
      @specline_update.txt3_id = new_txt3_text.id 
      if @specline.txt3.text.casecmp(@value) != 0
        #if new text is not similar to old text save change to text and create change record
          record_change         
      end
      @specline_update.save
    end
    render :text=>  @value   
  end  
 
  
  # PUT /projects/update_specline_4/id
  def update_specline_4
    authorize @specline
    @specline_update = @specline

    #application controller
    #removes white space and punctuation from end of text
    clean_text(params[:value])
    
    #value = new text
    if @value
    #check if similar text exists
##is this right???    
    txt4_check = Txt4.where(:text => @value).first
    
    txt4_exist = Txt4.where('BINARY text =?', @value).first
      if txt4_exist.blank?
         new_txt4_text = Txt4.create(:text => @value)
      else
         new_txt4_text = txt4_exist
      end
        
      #check if new text is similar to old text 
      @specline_update.txt4_id = new_txt4_text.id
      if txt4_check.blank?
        #if new text is not similar to old text save change to text and create change record
          record_change         
      end
      @specline_update.save
    end
    render :text=> params[:value]    
  end  

  
  # PUT /projects/update_specline_5/id
  def update_specline_5
    authorize @specline    
    @specline_update = @specline
    
    #application controller
    #removes white space and punctuation from end of text
    clean_text(params[:value])
    
    #value = new text
    if @value
    txt5_exist = Txt5.where('BINARY text =?', @value).first
      if txt5_exist.blank?
         new_txt5_text = Txt5.create(:text => @value)
      else
         new_txt5_text = txt5_exist
      end
    
      #check if new text is similar to old text 
      @specline_update.txt5_id = new_txt5_text.id 
      if @specline.txt5.text.casecmp(@value) != 0
        #if new text is not similar to old text save change to text and create change record
          record_change         
      end
      @specline_update.save
    end
    render :text=> params[:value] 
  end


  
  def xref_data
    authorize @specline

    #determin which clauses can be selected depending on clausetype of current specline    
    case @specline.clause.clauseref.clausetype_id
      when 4 ;  permissible_clausetypes = [5]
      when 3 , permissible_clausetypes = [4,5]
      when 2 , permissible_clausetypes = [3,4,5]  
    end
    
    #get txt5 value for line
    current_text = Txt5.where(:id => @specline.txt5_id).first
    
    #get all relevent clauses in project subsection
#get ids first to get list of unique clauses - otherwise list of clauses if repeated
    reference_clause_ids = Clause.joins(:speclines, :clauseref
                                ).where('speclines.project_id' => @specline.project_id, 'clauserefs.subsection_id' => @specline.clause.clauseref.subsection_id, 'clauserefs.clausetype_id' => permissible_clausetypes
                                ).pluck(:id).uniq.sort 
    reference_clauses = Clause.where(:id => reference_clause_ids)
   
    #create hash of options
    @reference_options = {}
    @reference_options['Not specified'] = 'Not specified'
    
    reference_clauses.each do |c|
      code = c.clause_code
      code_title = c.clause_code_title_in_brackets
      @reference_options[code] = code_title
    end
    #identify which is currently selected option - txt5 value
    @reference_options['selected'] = current_text.text

    #render as json for jeditable
    render :json => @reference_options
    
  end  


def update_product_key
    authorize @specline
  #key text returned
  @specline_update = @specline  
  key = params[:value]

    #get product identity pairs in clause which have been completed, not including current line
    product_identity_pairs = Specline.product_identity_pairs(@specline)
   
    #get product perform pairs in clause which have been completed, not including current line
    product_perform_pairs = Specline.product_perform_pairs(@specline)

    get_sub_clause_ids(@specline.clause_id)
    #get cpossible products for line
    #if specline linetype == 10 (identity pair)
    #get possible products for identity and perform pairs
    if product_identity_pairs.empty?
      if product_perform_pairs.empty?
        possible_products = Product.joins(:clauseproducts).where(
          'clauseproducts.clause_id' => @sub_clause_ids)  
      else
        possible_products = Product.joins(:clauseproducts, :instances => :charcs).where(
          'clauseproducts.clause_id' => @sub_clause_ids,
          'charcs.perform_id'=>  product_perform_pairs)        
      end
    else
      if product_perform_pairs.empty?
        possible_products = Product.joins(:clauseproducts, :descripts).where(
          'clauseproducts.clause_id' => @sub_clause_ids,
          'descripts.identity_id'=> product_identity_pairs) 
      else
        possible_products = Product.joins(:clauseproducts, :descripts, :instances => :charcs).where(
          'clauseproducts.clause_id' => @sub_clause_ids,
          'descripts.identity_id'=> product_identity_pairs,
          'charcs.perform_id'=> product_perform_pairs)     
      end        
    end
    #possible_product_ids = possible_products.collect{|x| x.id}.uniq    
  
  #establish type of key - identity or perform key
  #check possible identity keys possible products
  check_identkey_exist = Identkey.joins(:identities => :descripts).where('descripts.product_id' => possible_product.ids, :text => key).first
  
  #if identity key then linetype = 10
  if check_identkey_exist
    #update linetype
    if @specline_update.linetype_id != 10
      @specline_update.linetype_id = 10
      @specline_update.save
#insert change record event - because linetype has been changed?      
    end
    
    #if only one value option auto complete otherwise set value to 1 ('not specified')
    #estabish if pair exists for lintype, if not create  
    check_identity_ids = Identity.joins(:identkey, :descripts).where(
      'descripts.product_id' => possible_product_ids,
      'identkeys.text' => key
      ).collect{|x| x.id}.uniq
    
    if check_identity_ids.length == 1
      #save new identvalue for specline
      update_identity_id = check_identity_ids[0]  
    else
      #save or create identkey with 'not specified' value for specline     
      check_identity = Identity.where(:identvalue_id => 1, :identkey_id => check_identkey_exist.id).first_or_create 
      update_identity_id = check_identity.id     
    end
    @specline_update.identity_id = update_identity_id
    @specline_update.save
#insert change record event?
    
  else
    if @specline_update.linetype_id != 11
      @specline_update.linetype_id = 11
      @specline_update.save
#insert change record event - because linetype has been changed?      
    end
    
    #if only one value option auto complete otherwise set value to 1 ('not specified')
    #estabish if pair exists for lintype, if not create  
    check_perform_ids = Perform.joins(:performkey, :performvalue, :charcs => :instance).where(
      'instances.product_id' => possible_product_ids,
      'performkeys.text' => key
      ).collect{|x| x.id}.uniq
    

       
    if check_perform_ids.length == 1
      #save new identvalue for specline
      update_perform_id = check_perform_ids[0]  
    else
      #save or create identkey with 'not specified' value for specline
      check_performkey_exist = Performkey.where(:text => key).first     
      check_perform = Perform.where(:performvalue_id => 1, :performkey_id => check_performkey_exist.id).first_or_create 
      update_perform_id = check_perform.id     
    end
    @specline_update.perform_id = update_perform_id
    @specline_update.save
#insert change record event?    
  end
    #render :text=> params[:value]  
    render :update, :layout => false 
end


def update_product_value
    authorize @specline
  #value text returned
  @specline_update = @specline  

  if params[:value] == "Not specified"
    render :text => params[:value]
  else
  
  if @specline.linetype_id == 10
    if @specline.identity.identkey.text == "Manufacturer"
      company_id = params[:value]
      new_identity_pair = Identity.joins(:identvalue).where(:identkey_id => @specline.identity.identkey_id, 'identvalues.company_id' => company_id).first     
      render_value_text = new_identity_pair.identvalue.company.company_details  
    else
      identtxt_id = params[:value]
      new_identity_pair = Identity.joins(:identvalue).where(:identkey_id => @specline.identity.identkey_id, 'identvalues.identtxt_id' => identtxt_id).first
      render_value_text = new_identity_pair.identvalue.identtxt.text
    end
    @specline_update.identity_id = new_identity_pair.id
    @specline_update.save
    #record change      
  else
      performvalue_id = params[:value]    
      new_perform_pair = Perform.where(:performkey_id => @specline.perform.performkey_id, :performvalue_id  => performvalue_id).first
      render_value_text = new_perform_pair.performvalue.full_perform_value
      @specline_update.perform_id = new_perform_pair.id
      @specline_update.save
      #record change    
  end  
        
  render :text => render_value_text
  end   
end

  
  # PUT /speclines/1
  # PUT /speclines/1.xml
  def update
    authorize @specline
    @specline_update = @specline
    #private method to update txt1 values following change to specline_line linetype
    
    old_linetype = Linetype.find(@specline.linetype_id)
    new_linetype = Linetype.find(params[:specline][:linetype_id])  
    
    if old_linetype.txt1 != new_linetype.txt1  
      txt1_change_linetype(@specline, old_linetype, new_linetype)
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end 
    end
    #call to private method that records change to line in Changes table
    
    #only record change if linetype is changed ignoring txt1        
    old_linetype_array = [old_linetype.txt3, old_linetype.txt4, old_linetype.txt5, old_linetype.txt6]    
    new_linetype_array = [new_linetype.txt3, new_linetype.txt4, new_linetype.txt5, new_linetype.txt6]    
    if new_linetype_array != old_linetype_array
      record_change 
    end
        #if new linetype is for product data set identity and perform value pairs to 'not specified'
    if [10,11].include?(params[:specline][:linetype_id])
      @specline_update.update_attributes(:linetype_id => new_linetype.id, :perform_id => 1, :identity_id => 1)
    else
      @specline_update.update_attributes(params[:specline])
    end    
  
  end

  def delete_clause
    authorize @specline
         
    @array_of_lines_deleted = []
    

    @current_project = Project.where('id = ? AND company_id =?', @specline.project_id, current_user.company_id).first
    @current_revision = Revision.where('project_id = ?', @current_project.id).last
    
        
    selected_clause_title = @specline
    @clause_title_to_delete = @specline.id    
    #selected_clause_title.destroy
    
    #clause = Clause.find(@specline.clause_id)
    #adds in parent clause title line where clause has parent clause
    #add_parent_clause(clause, @current_project)

    
    clause_lines = Specline.where(:project_id => @specline.project_id, :clause_id => @specline.clause_id).order('clause_line')    
      clause_lines.each_with_index do |clause_line, i|

#TO DO: ENHANCEMENT
#get clause reference for clause to be delete
#check if speclines in same project and subsection have txt5 value equal to clause reference
#check_cross_reference = Specline.joins(:txt5, :clause => :clauseref).where(:project_id => @specline.project_id, 'clauserefs.subsection_id' => @specline.clause.clauseref.subsection_id, 'txt5s.text' => @specline.clause.clause_code).first
#if yes
#if check_cross_reference
 #get specline reference and run change on it
# update_txt5_delete_cross_refence(specline_id)
#end
#END OF TO DO
    
        @array_of_lines_deleted[i] = clause_line.id 
        @specline = clause_line
        #call to private method that record deletion of line in Changes table
        @clause_change_record = 2
                
        record_delete    
        clause_line.destroy   
      end
      
      @array_of_lines_deleted.compact
      
    previous_changes_to_clause = Change.where(:project_id => @current_project.id, :clause_id => @specline.clause_id, :revision_id => @current_revision.id)
    if !previous_changes_to_clause.blank?
      previous_changes_to_clause.each do |previous_change|
        previous_change.clause_add_delete = 2
        previous_change.save
      end    
    end 
    
    respond_to do |format|
      format.js  { render :delete_clause, :layout => false }
    end

  end

  # DELETE /speclines/1
  # DELETE /speclines/1.xml
  def delete_specline
       
        authorize @specline 
    
   # check_specline = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?',  @specline.clause_id, @specline.project_id, 0).order('clause_line')  
  
        @spec_line_div = @specline.id

        #change prefixs to clauselines in clause    
        txt1_delete_line(@specline)
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end                  
        @specline.destroy
        #call to private method that record deletion of line in Changes table
        record_delete
        
        #call to protected method in application controller that changes the clause_line ref in any subsequent speclines
        subsequent_specline_lines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', @specline.clause_id, @specline.project_id, @specline.clause_line).order('clause_line')        
        update_subsequent_specline_clause_line_ref(subsequent_specline_lines, 'delete', @specline)
        
            
        respond_to do |format|        
            format.js   { render :delete_spec, :layout => false }      
        end    
  end


def guidance
      @selected_specline = Specline.where('id =?', params[:spec_id]).first
      #clause = Clause.includes(:clauseref).where('id =?', params[:id]).first

      clause = Clause.where(:id => params[:id]).first
      @guidenote = Guidenote.where(:id => clause.guidenote_id).first
      @guide_sponsors = Sponsor.includes(:supplier).where(:subsection_id => clause.clauseref.subsection_id)

    respond_to do |format|
        format.js   { render :guidance, :layout => false}
    end
end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specline
      @specline = Specline.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specline_params
      params.require(:specline).permit(:project_id, :clause_id, :clause_line, :txt1_id, :txt2_id, :txt3_id, :txt4_id, :txt5_id, :txt6_id, :identity_id, :perform_id, :linetype_id)
    end

  def update_txt5_delete_cross_refence(specline_id)
     
    @specline = Specline.where(specline_id).first       
    @specline_update = @specline
    @specline_update.txt5_id = 1
    #create change record
    record_change         
    @specline_update.save

  end

    
end
