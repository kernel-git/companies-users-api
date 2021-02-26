# frozen_string_literal: true

class V1::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :description

  # Using serializer below
  has_many :company_user_connections, key: 'connections_with_users'

  class CompanyUserConnectionSerializer < ActiveModel::Serializer
    attributes :id, :role

    # Using UserSerializer 'cause default setup won't allow recursion
    belongs_to :user
  end
end
