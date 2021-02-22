# frozen_string_literal: true

class CompaniesSeeds
  def initialize; end

  def perform
    companies = []

    5.times do
      company = Company.new({
                              name: Faker::Lorem.word,
                              description: Faker::Lorem.paragraph
                            })
      companies << company
    end
    5.times do |index|
      log_errors(companies[index]) unless companies[index].save
    end
  end
end
