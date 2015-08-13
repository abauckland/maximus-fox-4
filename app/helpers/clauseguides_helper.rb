module ClauseguidesHelper

  def has_guide(clause_id, plan_id)

    @clauseguide = Clauseguide.where(:clause_id => clause_id, :plan_id => plan_id).first

    if @clauseguide.blank?
      false
    else
      @clauseguide
    end
  end

  def associated_clauses(clauseguide)
    
    clausguides = Clauseguide.where(:guidenote_id => clauseguide.guidenote_id)
    if clausguides.length > 1
      true
    else
      false
    end
    
  end


end