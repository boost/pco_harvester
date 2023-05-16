# frozen_string_literal: true

class LoadWorker < ApplicationWorker
  def child_perform(load_job, harvest_job_id, transformed_records)
    harvest_job = HarvestJob.find(harvest_job_id)
    sent_records = 0
    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, harvest_job.destination).call
      sent_records += 1
    end
    update_load_report(load_job, sent_records)
  end

  def update_load_report(load_job, sent_records)
    load_job.reload
    load_job.update(records_sent_to_api: load_job.records_sent_to_api + sent_records)
  end
end
