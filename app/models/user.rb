# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :company_user_connections, inverse_of: :user, dependent: :destroy
  has_many :companies, through: :company_user_connections

  accepts_nested_attributes_for :company_user_connections, allow_destroy: true

  validates_presence_of :first_name, :last_name, :email
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'is not a valid email' }

  def admin_in?(company)
    company_user_connections.filter_by_role('admin').where(company: company).any?
  end
end
