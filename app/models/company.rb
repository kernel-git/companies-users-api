# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :company_user_connections, inverse_of: :company, dependent: :destroy
  has_many :users, through: :company_user_connections

  accepts_nested_attributes_for :company_user_connections, allow_destroy: true

  validates_presence_of :name

  def have_admin?
    company_user_connections.any? { |conn| conn.role.downcase == 'admin' }
  end
end
