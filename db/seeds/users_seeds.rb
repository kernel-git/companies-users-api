# frozen_string_literal: true

class UsersSeeds
  def perform
    20.times do
      user = User.new(
        email: Faker::Internet.unique.email,
        password: '11111111',
        password_confirmation: '11111111',
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      )
      logger.error user.errors.full_messages unless user.save
    end
  end
end
