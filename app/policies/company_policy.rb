# frozen_string_literal: true

class CompanyPolicy
  attr_reader :user, :company

  def initialize(user, company)
    @user = user
    @company = company
  end

  def create?
    company.have_admin?
  end

  def update?
    user.admin?(company)
  end

  def destroy?
    user.admin?(company)
  end
end
