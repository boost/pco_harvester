# frozen_string_literal: true

FactoryBot.define do
  factory :transformation_job do
    status { 'queued' }
    page { 1 }

    transformation_definition
    extraction_job
  end
end
