# frozen_string_literal: true

FactoryBot.define do
  factory :harvest_job do
    harvest_definition
    extraction_job

    trait(:completed) do
      status { 'completed' }

      after(:create) do |harvest_job|
        transformation_definition = create(:transformation_definition, content_partner: harvest_job.content_partner)
        harvest_job.transformation_jobs = create_list(:transformation_job, 2) do |transformation_job, i|
          transformation_job.update(transformation_definition:, harvest_job:, status: 'completed', page: i)
        end

        harvest_job.load_jobs = create_list(:load_job, 2, status: 'completed')
      end
    end
  end
end
