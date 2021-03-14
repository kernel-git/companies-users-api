# frozen_string_literal: true

class V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email

  # Using serializer below
  has_many :company_user_connections, key: 'connections_with_companies'

  class CompanyUserConnectionSerializer < ActiveModel::Serializer
    attributes :id, :role

    # Using CompanySerializer 'cause default setup won't allow recursion
    belongs_to :company
  end
end
