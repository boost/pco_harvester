# frozen_string_literal: true

FactoryBot.define do
  factory :delete_job do
    status { 'queued' }
    page { 1 }

    harvest_job
  end
end
