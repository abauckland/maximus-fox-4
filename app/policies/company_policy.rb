class CompanyPolicy < Struct.new(:user, :company)

  def edit?
    if user.admin? || user.owner?
      company.id == user.company_id
    end
  end

  def update?
    if user.admin? || user.owner?
      company.id == user.company_id
    end
  end

end