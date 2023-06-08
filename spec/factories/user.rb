# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email    { Faker::Internet.email }
    password { 'password' }
    two_factor_setup { true }
  end
end
