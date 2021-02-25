# frozen_string_literal: true

class CompaniesSeeds
  def perform
    5.times do
      company = Company.new(
                              name: Faker::Lorem.word,
                              description: Faker::Lorem.paragraph
                            )
      logger.error company.errors.full_messages unless company.save
    end
  end
end
