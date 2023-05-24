# frozen_string_literal: true

class LoadWorker < ApplicationWorker
  def child_perform(load_job, transformed_records)
    transformed_records = JSON.parse(transformed_records)

    sent_records = 0
    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, load_job.harvest_job.destination).call
      sent_records += 1
    end
    update_load_report(load_job, sent_records)
  end

  def update_load_report(load_job, sent_records)
    load_job.reload
    load_job.update(records_loaded: load_job.records_loaded + sent_records)
  end
end
