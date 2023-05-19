# frozen_string_literal: true

FactoryBot.define do
  factory :destination do
    name { Faker::Company.name }
    url  { 'www.google.co.nz' }
    api_key { 'testkey' }
  end
end
