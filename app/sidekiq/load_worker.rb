# frozen_string_literal: true

class LoadWorker < ApplicationWorker
  include Sidekiq::Job

  def child_perform(load_job, harvest_job_id, transformed_records)
    harvest_job = HarvestJob.find(harvest_job_id)
    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, harvest_job.destination).call
      load_job.records_sent_to_api += 1
      load_job.save!
    end
  end
end
