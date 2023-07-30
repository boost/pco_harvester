# frozen_string_literal: true

class DeleteWorker < ApplicationWorker
  def child_perform(delete_job, records)
    records_to_delete = JSON.parse(records)

    deleted_records = 0
    records_to_delete.each do |record|
      Delete::Execution.new(record, delete_job).call
      deleted_records += 1
    end

    update_delete_report(delete_job, deleted_records)
  end

  def update_delete_report(delete_job, deleted_records)
    delete_job.reload
    delete_job.update(records_deleted: delete_job.records_deleted + deleted_records)
  end
end
