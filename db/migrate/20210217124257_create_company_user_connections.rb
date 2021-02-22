# frozen_string_literal: true

class CreateCompanyUserConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :company_user_connections do |t|
      t.string :role
      t.belongs_to :user
      t.belongs_to :company

      t.timestamps
    end
  end
end
