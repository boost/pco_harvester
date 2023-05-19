# frozen_string_literal: true

FactoryBot.define do
  factory :transformation_job do
    status { 'queued' }
    page { 1 }

    # before(:create) do |transformation_job|
    #   binding.pry
    #   transformation_job.transformation_definition = create(:transformation_definition)
    # end

    transformation_definition
    harvest_job
    extraction_job
  end
end
