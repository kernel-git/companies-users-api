# frozen_string_literal: true

class CompanyUserConnection < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates_presence_of :user, :company, :role
end
