# frozen_string_literal: true

FactoryBot.define do
  factory :transformation_definition do
    name { Faker::Company.name }
    record_selector { '$..results' }

    extraction_job
    content_source
  end
end
