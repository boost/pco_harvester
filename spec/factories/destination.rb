# frozen_string_literal: true

FactoryBot.define do
  factory :destination do
    name { Faker::Company.name }
    url  { 'http://www.localhost:3000' }
    api_key { 'testkey' }
  end
end
