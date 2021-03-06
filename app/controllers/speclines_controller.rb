class SpeclinesController < ApplicationController

  skip_before_filter :authenticate_user!, :only => [:xref_data]

  before_action :set_specline
  before_action :set_project, only: [:delete_clause]
  before_action :set_revision, only: [:delete_clause, :move_specline]


  # GET
  def new_specline
    #call to protected method in application controller that changes the clause_line ref in any subsequent speclines
    subsequent_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', @specline.clause_id, @specline.project_id, @specline.clause_line).order('clause_line')
    update_subsequent_specline_clause_line_ref(subsequent_speclines, 'new', @specline)

    if @specline.clause_line == 0
      case @specline.clause.clauseref.clausetype_id
        when 1, 6, 7, 8, 10, 11, 12 ;  linetype_id = 7
        when 2, 3, 4, 5 ;  linetype_id = 8
      end
    else
      linetype_id = @specline.linetype_id
    end 

    #if specline is a product or reference line (linetype 10, 11 or 12)
    if [10,11].include?(@specline.linetype_id)
      @new_specline = Specline.create(:id => nil, :project_id => @specline.project_id, :clause_id => @specline.clause_id, :clause_line => @specline.clause_line + 1, :linetype_id => linetype_id)
    else
      @new_specline = Specline.create(@specline.attributes.merge(:id => nil, :clause_line => @specline.clause_line + 1, :linetype_id => linetype_id))
    end

    #call to private method that records addition of line in Changes table
    record_new(@new_specline, event_type)
    #change prefixs to clauselines in clause
    txt1_insert_line(@new_specline, @specline, subsequent_speclines)
    if !@subsequent_prefixes.blank?
      @subsequent_prefixes.compact
    end

    respond_to do |format|
        format.js   { render :new_specline, :layout => false }
    end
  end
#################################

  def move_specline
    #approach followed:
    #1. act as if selected line has been removed from clause
    #2. update all clause lines to reflect removeal of selected line - clause_line ref and prefixes
    #3. get new location
    #4. act as if added into clause
    #5. update all clause lines to reflect removeal of selected line - clause_line ref and prefixes 
    #6. record changs where line has been moved to a different clause
    #7. save changes to selected line - with new location information

    @selected = @specline #obtained in before filter

    #get array of linetypes that have a prefix
    prefixed_linetypes_array = Linetype.where('txt1 = ?', 1).ids

#UPDATING OLD LOCATAION
    update_old_location_on_move(@selected, prefixed_linetypes_array)

#ASCERTAIN NEW LOCATAION
    #covers following conditions
    #if line moved to different clause
    #if line moved within same clause, to location above current one
    #if line moved within same clause, to location below current one

#get new position 
    #array of specline ids for the whole page
    #find location of selected specline in array
    array_as_string = params[:table_id_array]
    id_array = array_as_string.split(",").map { |s| s.to_s }
    array_location = id_array.index(params[:id])

#get speclines in new clause
    #id of line above new above position
    #if line is at top of clausetype
    if array_location == 0
      #line above - first line of clausetype in project - used to establish identity of the first clause  
      new_above_specline = Specline.where('clause_id = ? AND project_id = ? AND clause_line = ?', @selected.clause_id,  @selected.project_id, 0).first  
    else
      #line above - used to establish identity of the clause the line has been moved to
      new_above_specline = Specline.where(:id => id_array[array_location - 1]).first
    end

#UPDATING NEW LOCATAION
    update_new_location_on_move(new_above_specline, @selected, prefixed_linetypes_array)

#VARIABLES FOR VIEW
    @old_specline_ref = @selected.id
    @new_above_specline = new_above_specline
    @updated_specline = Specline.where(:id => @selected.id).first

#UPDATE & TRACKING CHANGES
    #only needs to be tracked if line is moved from one clause to another
    if new_above_specline.clause_id != @selected.clause_id
      @new_specline = Specline.create(@selected.attributes.merge(:id => nil, :txt1_id => @new_location_prefix_id, :clause_line => @new_location_clause_line, :clause_id => @new_location_clause_id))      
      previous_change_to_clause = Alteration.where('project_id = ? AND clause_id = ? AND revision_id =?', @new_specline.project_id, @new_specline.clause_id, @revision.id).order('created_at').last
      if previous_change_to_clause
        event_type = previous_change_to_clause.clause_add_delete
      else
        event_type
      end
      record_new(@new_specline, event_type)
#change record - what if there is no previous??
      @selected.destroy
      record_delete(@selected, event_type)
      @updated_specline = @new_specline
    else
      @selected.update(:txt1_id => @new_location_prefix_id, :clause_line => @new_location_clause_line)
      @updated_specline = @selected
    end

    respond_to do |format|
      format.js   { render :move_specline, :layout => false }
    end

  end

  def move_up
    @selected = @specline #obtained in before filter
    
    #get array of linetypes that have a prefix
    prefixed_linetypes_array = Linetype.where('txt1 = ?', 1).ids

#UPDATING OLD LOCATAION
    update_old_location_on_move(@selected, prefixed_linetypes_array)

#ASCERTAIN NEW LOCATAION
    #covers following conditions
    #if line moved to different clause
    #if line moved within same clause, to location above current one
    #if line moved within same clause, to location below current one

#get new position 
    #array of specline ids for the whole page
    #find location of selected specline in array
    array_as_string = params[:table_id_array]
    id_array = array_as_string.split(",").map { |s| s.to_s }
    array_location = id_array.index(params[:id])

#get speclines in new clause
    #id of line above new above position
    #if line is at top of clausetype
    if array_location == 0
      #line above - first line of clausetype in project - used to establish identity of the first clause
      new_above_specline = Specline.where('clause_id = ? AND project_id = ? AND clause_line = ?', @selected.clause_id,  @selected.project_id, 0).first  
    else
      #line above - used to establish identity of the clause the line has been moved to
      new_above_specline = Specline.where(:id => id_array[array_location - 1]).first
    end

#UPDATING NEW LOCATAION
    update_new_location_on_move(new_above_specline, @selected, prefixed_linetypes_array)
  end


  def move_down
    @selected = @specline #obtained in before filter

    #get array of linetypes that have a prefix
    prefixed_linetypes_array = Linetype.where('txt1 = ?', 1).ids

#UPDATING OLD LOCATAION
    update_old_location_on_move(@selected, prefixed_linetypes_array)

#UPDATING NEW LOCATAION
    update_new_location_on_move(new_above_specline, @selected, prefixed_linetypes_array)
  end

#if line is moved up one position
#new_clause_line = @selected.clause_line - 1
#if line is moved down one position
#new_clause_line = @selected.clause_line + 1
#new location equals:
#Specline.where(:project_id => @selected.project_id, :clause_id => @selected.clause_id, :clause_line => @selected.clause_line - 1).first




  # GET /speclines/1/edit
  def edit
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
    #removes white space and punctuation from end of text
    clean_text(params[:value])
    #create duplicate record for alteration tracking
    old_specline = @specline.dup

    if @value == ""
      new_txt3 = Txt3.first #if no value then set text to 'not specified'
    else
      #save new text if exact match does not exist in Txt table
      #get new text info
      txt3_exist = Txt3.where('BINARY text =?', @value).first 
      if txt3_exist.blank?
        new_txt3 = Txt3.create(:text => @value)
      else
        new_txt3 = txt3_exist
      end
    end
    #save changes
    @specline.update(:txt3_id => new_txt3.id)
    #check if new text is similar to old text 
    if @specline.txt3.text.casecmp(old_specline.txt3.text) != 0
      #if new text is not similar to old text record change to text
      record_change(old_specline, @specline)
    end
    render :text=> params[:value]
  end


  # PUT /projects/update_specline_4/id
  def update_specline_4

    clean_text(params[:value])
    old_specline = @specline.dup

    if @value == ""
      new_txt4 = Txt4.first
    else
      txt4_exist = Txt4.where('BINARY text =?', @value).first
      if txt4_exist.blank?
         new_txt4 = Txt4.create(:text => @value)
      else
         new_txt4 = txt4_exist
      end
    end

    @specline.update(:txt4_id => new_txt4.id)

    if @specline.txt4.text.casecmp(old_specline.txt4.text) != 0
      record_change(old_specline, @specline)
    end
    render :text=> params[:value]
  end


  # PUT /projects/update_specline_5/id
  def update_specline_5

    clean_text(params[:value])
    old_specline = @specline.dup

    if @value == ""
      new_txt5 = Txt5.first
    else
      txt5_exist = Txt5.where('BINARY text =?', @value).first
      if txt5_exist.blank?
         new_txt5 = Txt5.create(:text => @value)
      else
         new_txt5 = txt5_exist
      end
    end

    @specline.update(:txt5_id => new_txt5.id)

    if @specline.txt5.text.casecmp(old_specline.txt5.text) != 0
      record_change(old_specline, @specline)
    end
    render :text=> params[:value]
  end


  def xref_data

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
                                ).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                                ).pluck(:id).uniq

    #create hash of options
    @reference_options = {}
    @reference_options['Not specified'] = 'Not specified'
    
    reference_clause_ids.each do |c|

      reference_clause = Clause.where(:id => c).first

      code_title = reference_clause.clause_code + ' (' + reference_clause.clausetitle.text.to_s + ')'
      code = reference_clause.clause_code
      @reference_options[code] = code_title
    end
    #identify which is currently selected option - txt5 value
    @reference_options['selected'] = current_text.text

    #render as json for jeditable
    render :json => @reference_options

  end


def update_product_key

  #key text returned
  @specline_update = @specline
  key = params[:value]

  old_specline = @specline.dup

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
        possible_products = Product.joins(:clauseproducts
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids)
      else
        possible_products = Product.joins(:clauseproducts, :instances => :charcs
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids,'charcs.perform_id'=>  product_perform_pairs)
      end
    else
      if product_perform_pairs.empty?
        possible_products = Product.joins(:clauseproducts, :descripts
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids,'descripts.identity_id'=> product_identity_pairs) 
      else
        possible_products = Product.joins(:clauseproducts, :descripts, :instances => :charcs
                                  ).where('clauseproducts.clause_id' => @sub_clause_ids,'descripts.identity_id'=> product_identity_pairs,'charcs.perform_id'=> product_perform_pairs)
      end
    end
    possible_product_ids = possible_products.collect{|x| x.id}.uniq

  #establish type of key - identity or perform key
  #check possible identity keys possible products
  check_identkey_exist = Identkey.joins(:identities => :descripts).where('descripts.product_id' => possible_product.ids, :text => key).first

  #if identity key then linetype = 10
  if check_identkey_exist
    #update linetype
    if @specline.linetype_id != 10
      @specline.update(:linetype_id => 10)
     # @specline_update.linetype_id = 10
      #@specline_update.save
      record_change(old_specline, @specline)
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
    @specline.update(:identity_id => update_identity_id)
    #@specline_update.identity_id = update_identity_id
    #@specline_update.save
    record_change(old_specline, @specline) 

  else
    if @specline.linetype_id != 11
      @specline.update(:linetype_id => 11)
      #@specline_update.linetype_id = 11
      #@specline_update.save
      record_change(old_specline, @specline)
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
    #@specline_update.perform_id = update_perform_id
    #@specline_update.save
    @specline.update(:perform_id => update_perform_id)
    record_change(old_specline, @specline)
  end
    #render :text=> params[:value]
    render :update, :layout => false
end


def update_product_value

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
    @specline_update.update(:identity_id => new_identity_pair.id)
    #@specline_update.identity_id = new_identity_pair.id
    #@specline_update.save
    record_change(old_specline, @specline)
  else
      performvalue_id = params[:value]
      new_perform_pair = Perform.where(:performkey_id => @specline.perform.performkey_id, :performvalue_id  => performvalue_id).first
      render_value_text = new_perform_pair.performvalue.full_perform_value
      @specline_update.update(:perform_id => new_perform_pair.id)
      #@specline_update.perform_id = new_perform_pair.id
     # @specline_update.save
      record_change(old_specline, @specline)
  end

  render :text => render_value_text
  end
end


  # PUT /speclines/1
  # PUT /speclines/1.xml
  def update

    old_specline = @specline.dup

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
      record_change(old_specline, @specline)
    end
        #if new linetype is for product data set identity and perform value pairs to 'not specified'
    if [10,11].include?(params[:specline][:linetype_id])
      @specline.update_attributes(:linetype_id => new_linetype.id, :perform_id => 1, :identity_id => 1)
    else
      @specline.update(specline_params)
    end

  end

  def delete_clause

      @array_of_lines_deleted = []
      #required for js response
      @clause_title_to_delete = @specline.id
      dup_specline = @specline.dup

      speclines_to_delete = Specline.where(:project_id => @specline.project_id, :clause_id => @specline.clause_id).order('clause_line')
      revision = Revision.where(:project_id => @project.id).where.not(:rev => nil).order('created_at').last
      if revision
        speclines_to_delete.each_with_index do |specline, i|
          @array_of_lines_deleted[i] = specline.id 
          record_delete(specline, 2)
          specline.destroy
        end
        clause = Clause.find(@specline.clause_id)
        update_clause_alterations(clause, @project, revision, 2)
      else
        speclines_to_delete.each_with_index do |specline, i|
          @array_of_lines_deleted[i] = specline.id 
          specline.destroy
        end
      end

      @array_of_lines_deleted.compact

      #find if any clauses are in current subsection after changes
      get_valid_spline_ref = Specline.joins(:clause => [:clauseref]
                                    ).where(:project_id => @project.id, 'clauserefs.subsection_id' => dup_specline.clause.clauseref.subsection_id
                                    ).last

#TODO if no clauses in subsection redirect to subsection manager
      if get_valid_spline_ref.blank?
        #update all alteration records for section so event_type = 3
        previous_alterations = Alterations.all_changes(@project, @revision
                                         ).joins(:clause => [:clauseref]
                                         ).where('clauserefs.subsection_id' => dup_specline.clause.clauseref.subsection_id)

#TODO this needs to update all reocrds as per delete section - check this is correct
        previous_alterations.each do |alteration|
          alteration.update(:clause_add_delete => 3)
        end
      end

    #selected_clause_title.destroy

    #clause = Clause.find(@specline.clause_id)
    #adds in parent clause title line where clause has parent clause
    #add_parent_clause(clause, @current_project)

#    clause_lines = Specline.where(:project_id => @specline.project_id, :clause_id => @specline.clause_id).order('clause_line')    
#      clause_lines.each_with_index do |clause_line, i|

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

#        @array_of_lines_deleted[i] = clause_line.id 
 #       @specline = clause_line
        #call to private method that record deletion of line in Changes table
#        clause_event_type = 2

 #       record_delete(@specline, event_type)
 #       clause_line.destroy
#      end

 #     @array_of_lines_deleted.compact

#    previous_changes = Alteration.where(:project_id => @project.id, :clause_id => @specline.clause_id, :revision_id => @revision.id)
#    if !previous_changes.blank?
#      previous_changes.each do |previous_change|
#        previous_change.clause_add_delete = 2
#        previous_change.save
#      end
#    end

    respond_to do |format|
      format.js  { render :delete_clause, :layout => false }
    end

  end

  # DELETE /speclines/1
  # DELETE /speclines/1.xml
  def delete_specline

   # check_specline = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?',  @specline.clause_id, @specline.project_id, 0).order('clause_line')  

        @spec_line_div = @specline.id

        #change prefixs to clauselines in clause
        txt1_delete_line(@specline)
        if !@subsequent_prefixes.blank?
          @subsequent_prefixes.compact
        end
        #call to private method that record deletion of line in Alterations table
        record_delete(@specline, event_type)
        @specline.destroy

        #call to protected method in application controller that changes the clause_line ref in any subsequent speclines
        subsequent_specline_lines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', @specline.clause_id, @specline.project_id, @specline.clause_line).order('clause_line')        
        update_subsequent_specline_clause_line_ref(subsequent_specline_lines, 'delete', @specline)


        respond_to do |format|
            format.js   { render :delete_spec, :layout => false }
        end
  end


  def guidance

    @guidenote = Guidenote.find(params[:clauseguide_id])

    respond_to do |format|
        format.js   { render :guidance, :layout => false}
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specline
      @specline = Specline.find(params[:id])
    end

    def set_project
      @project = Project.joins(:speclines).where('speclines.id' => params[:id]).first
    end

    def set_revision
      @revision = Revision.joins(:project => :speclines).where('speclines.id' => params[:id]).last
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def specline_params
      params.require(:specline).permit(:project_id, :clause_id, :clause_line, :txt1_id, :txt2_id, :txt3_id, :txt4_id, :txt5_id, :txt6_id, :identity_id, :perform_id, :linetype_id)
    end

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

    def update_txt5_delete_cross_refence(specline_id)

      @specline = Specline.where(specline_id).first
      old_specline = @specline.dup
                    
      @specline.update(:txt5_id => 1)
      #create change record
      record_change(old_specline, @specline)
    end



    def update_old_location_on_move(selected, prefixed_linetypes_array)

    #UPDATING OLD LOCATAION
    #get speclines in old clause
        #return list of lines below selected line in the same clause and the line above selected line
        old_clause_line_above = @selected.clause_line - 2 
        previous_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', selected.clause_id,  selected.project_id, old_clause_line_above).order('clause_line')
        previous_speclines_length = previous_speclines.ids.length

        #id of line above old position
        old_above_specline = previous_speclines[0]
        #id of line below old position
        old_below_specline = previous_speclines[2]

        last_array_item_ref = previous_speclines_length - 1 #total number of lines will be one less, because selected line has been removed

    #update clause_line refs
        #act as if selected line has been removed from clause
        #tidy up clause of selected line
        #renumber clause_line ref for lines below selected line
        if previous_speclines_length > 2 #if there is a line after the selected line
          for i in (2..last_array_item_ref) do #for each line in the clause below the selected line
            new_clause_line = old_above_specline.clause_line - 1 + i #determine new clause_line ref for line
            specline_to_change = previous_speclines[i].update(:clause_line => new_clause_line)#update clause_line refer for line
          end
        end

    #update prefixes
        #check if line had prefix
        #renumber prefixes
        if previous_speclines_length > 2 #if there is a line after the selected line
          # if next line in clause is prefixed update all subsequent prefixed lines
          if prefixed_linetypes_array.include?(old_below_specline.linetype_id)
            #set prefix reference
            #if line before selected line has prefix:
            #1. prefixes of subsequent lines will follow on
            #2. else prefixes of subsequent lines will start from 'a'.
            if prefixed_linetypes_array.include?(old_above_specline.linetype_id)
              next_txt1_id = old_above_specline.txt1_id + 1
            else
              next_txt1_id = 1
            end

              previous_prefixes = []
              previous_speclines[2..last_array_item_ref].each_with_index do |line, n|
                check_linetype = Linetype.where(:id => line.linetype_id).first
                if check_linetype.txt1 == true
                  next_txt1_id = (next_txt1_id + n) #because n starts at 0
                  line.update(:txt1_id => next_txt1_id)
                  txt1_text = Txt1.where(:id => next_txt1_id).first
                  previous_prefixes[n] = [line.id, txt1_text.text]
                else
                  break
                end
              end
           # if @subsequent_prefixes
              @previous_prefixes = previous_prefixes.compact
           # end
          end
        end
    end


    def update_new_location_on_move(new_above_specline, selected, prefixed_linetypes_array)

        @new_location_clause_id = new_above_specline.clause_id

#        next_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', new_above_specline.clause_id,  new_above_specline.project_id, new_above_specline.clause_line).order('clause_line')
        next_speclines = Specline.where.not(:id => selected.id).where('clause_id = ? AND project_id = ? AND clause_line > ?', new_above_specline.clause_id,  new_above_specline.project_id, new_above_specline.clause_line).order('clause_line')

        next_specline_ids = next_speclines.ids.compact
        next_speclines_length = next_specline_ids.length
#        index_selected = next_specline_ids.index(selected.id)
        last_array_item_ref = next_speclines_length - 1#total number of lines will be one less because of line above new location must be removed

        #id of line above new position
        #new_above_specline# = new_above_specline.id#next_speclines[0]
        #id of line below new position
        new_below_specline = next_speclines[0]

    #update clause_line refs
        #act as if selected line has been added to clause
        #tidy up clause
        #renumber clause_line ref for lines below the new location of the selected line
        if next_speclines_length > 0 #if there is a line after the new location for the selected line
          for i in (0..last_array_item_ref) do #for each line in the clause below the selected line
            new_clause_line = new_above_specline.clause_line + 2 + i #determine new clause_line ref for line
            #omit seleted line from update
#            if i != index_selected
              specline_to_change = next_speclines[i].update(:clause_line => new_clause_line)#update clause_line refer for line
            end
#          end
        end
        @new_location_clause_line = new_above_specline.clause_line + 1

    #update prefixes
        #if line below has prefix update prefixes
        # - if line above has prefix move prefixes on one
        # - if line above has no prefix
        # =>  if new line has prefix, start prefixes after
        # =>  else set prefix to start with first line below
        if prefixed_linetypes_array.include?(new_above_specline.linetype_id)
          if prefixed_linetypes_array.include?(selected.linetype_id)
            @new_location_prefix_id = new_above_specline.txt1_id + 1
            new_below_prefix_id = new_above_specline.txt1_id + 2
          else
            @new_location_prefix_id = 1
            new_below_prefix_id = 1
          end
        else
          if prefixed_linetypes_array.include?(selected.linetype_id)
            @new_location_prefix_id = 1
            new_below_prefix_id = 2
          else
            @new_location_prefix_id = 1
            new_below_prefix_id = 1
          end
        end

        if next_speclines_length > 0
          if prefixed_linetypes_array.include?(new_below_specline.linetype_id)
            # update_subsequent_lines_on_move(next_speclines[0..last_array_item_ref], new_below_prefix_id)
            subsequent_prefixes = []
            next_speclines[0..last_array_item_ref].each_with_index do |line, n|
              #omit seleted line from update 
#              if n != index_selected 
                check_linetype = Linetype.where(:id => line.linetype_id).first
                if check_linetype.txt1 == true
                  next_txt1_id = (new_below_prefix_id + n) #because n starts at 0
                  line.update(:txt1_id => next_txt1_id)
                  txt1_text = Txt1.where(:id => next_txt1_id).first
                  subsequent_prefixes[n] = [line.id, txt1_text.text]
                else
                  break
                end
#              end
            end

            if subsequent_prefixes
              @subsequent_prefixes = subsequent_prefixes.compact
            end 
          end
        end
    end 


    def event_type
      #indicate type event that addition of the specline is associated with
      #1 => line added/deleted/changed
      #2 => clause added/deleted
      #3 => subsection added/deleted
      #information used in reporting changes to the document
      return 1
    end
    
end
