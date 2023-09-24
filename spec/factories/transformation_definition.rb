# frozen_string_literal: true

FactoryBot.define do
  factory :transformation_definition do
    record_selector { '$..results' }

    extraction_job
    pipeline
  end
end
