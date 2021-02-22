# frozen_string_literal: true

class UsersSeeds
  def initialize; end

  def perform
    users = []

    20.times do
      user = User.new({
                        email: Faker::Internet.unique.email,
                        password: '11111111',
                        password_confirmation: '11111111',
                        first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name
                      })
      users << user
    end
    20.times do |index|
      log_errors(users[index]) unless users[index].save
    end
  end
end
