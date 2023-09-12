# frozen_string_literal: true

class TransformationWorker < ApplicationWorker
  def child_perform(transformation_job)
    @transformation_job = transformation_job
    @harvest_job = @transformation_job.harvest_job

    transformed_records = transform_records(transformation_job.page).map(&:to_hash)

    valid_records       = select_valid_records(transformed_records)
    rejected_records    = transformed_records.select { |record| record['rejection_reasons'].present? }
    deleted_records     = transformed_records.select { |record| record['deletion_reasons'].present? }

    queue_load_worker(valid_records)
    queue_delete_worker(deleted_records)

    update_transformation_report(valid_records, rejected_records, deleted_records)
  end

  def transform_records(page)
    Transformation::Execution.new(
      @transformation_job.records(page),
      @transformation_job.transformation_definition.fields
    ).call
  end

  def select_valid_records(records)
    records.select do |record|
      record['rejection_reasons'].blank? && record['deletion_reasons'].blank?
    end
  end

  def queue_load_worker(records)
    return if records.empty?

    load_job = LoadJob.create(harvest_job: @harvest_job, page: @transformation_job.page,
                              api_record_id: @transformation_job.api_record_id)

    LoadWorker.perform_async(load_job.id, records.to_json)
  end

  def queue_delete_worker(records)
    return if records.empty?

    delete_job = DeleteJob.create(harvest_job: @harvest_job, page: @transformation_job.page)
    DeleteWorker.perform_async(delete_job.id, records.to_json)
  end

  def update_transformation_report(valid_records, rejected_records, deleted_records)
    @transformation_job.reload
    @transformation_job.update(
      records_transformed: @transformation_job.records_transformed + valid_records.count,
      records_rejected: @transformation_job.records_rejected + rejected_records.count,
      records_deleted: @transformation_job.records_deleted + deleted_records.count
    )
  end
end
