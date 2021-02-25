# frozen_string_literal: true

class CompanyUserConnection < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates_presence_of :user, :company, :role

  scope :filter_by_role, -> (role) { where(self.arel_table[:role].matches("%#{role.downcase}%")) }
end
