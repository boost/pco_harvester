# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_definition do
    name { Faker::Company.name }
    source_id { 'test' }

    association :content_partner
    association :extraction_definition
    association :transformation_definition
    association :destination
  end
end
