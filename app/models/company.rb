# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :users, through: :company_user_connections
  has_many :company_user_connections, inverse_of: :company, dependent: :destroy

  accepts_nested_attributes_for :company_user_connections, allow_destroy: true

  validates_presence_of :name

  def have_admin?
    array = company_user_connections.map { |conn| conn.role.downcase }
    array.include?('admin')
  end

  def json
    to_json(only: %i[id name description], include: {
              company_user_connections: {
                only: %i[id role], include: {
                  user: { only: %i[id first_name last_name email] }
                }
              }
            })
  end
end
