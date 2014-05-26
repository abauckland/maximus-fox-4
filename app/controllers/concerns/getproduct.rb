module Getproduct

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

end