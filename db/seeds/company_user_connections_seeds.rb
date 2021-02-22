# frozen_string_literal: true

class CompanyUserConnectionsSeeds
  def initialize; end

  def perform
    connections = []

    30.times do
      connection = CompanyUserConnection.new({
                                               user_id: Faker::Number.within(range: 1..20),
                                               company_id: Faker::Number.within(range: 1..5),
                                               role: %w[admin manager agent teacher student ceo].sample
                                             })
      connections << connection
    end
    30.times do |index|
      log_errors(connections[index]) unless connections[index].save
    end
  end
end
