# frozen_string_literal: true

class CompanyUserConnectionsSeeds
  def perform
    30.times do
      connection = CompanyUserConnection.new(
                                               user_id: Faker::Number.within(range: 1..20),
                                               company_id: Faker::Number.within(range: 1..5),
                                               role: %w[admin manager agent teacher student ceo].sample
                                             )
      logger.error connection.errors.full_messages unless connection.save
    end
  end
end
