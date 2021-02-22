# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :companies, through: :company_user_connections
  has_many :company_user_connections, inverse_of: :user, dependent: :destroy

  accepts_nested_attributes_for :company_user_connections, allow_destroy: true

  validates_presence_of :first_name, :last_name, :email
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'is not a valid email' }

  def admin?(company)
    company_user_connections.where(CompanyUserConnection.arel_table[:role].matches('%admin%'))
                            .where(company: company).any?
  end

  def json
    to_json(only: %i[id first_name last_name email], include: {
              company_user_connections: {
                only: %i[id role], include: {
                  company: { only: %i[id name description] }
                }
              }
            })
  end
end
