# frozen_string_literal: true

class TransformationWorker < ApplicationWorker
  def child_perform(transformation_job)
    @transformation_job = transformation_job
    @harvest_job = @transformation_job.harvest_job

    transformed_records = transform_records(transformation_job.page).map(&:to_hash)

    valid_records       = transformed_records.select do |record|
      record['rejection_reasons'].blank? && record['deletion_reasons'].blank?
    end
    rejected_records    = transformed_records.select { |record| record['rejection_reasons'].present? }
    deleted_records     = transformed_records.select { |record| record['deletion_reasons'].present? }

    queue_load_worker(valid_records)
    queue_delete_worker(deleted_records) unless deleted_records.empty?

    update_transformation_report(valid_records, rejected_records, deleted_records)
  end

  def transform_records(page)
    transformation_definition_fields = @transformation_job.transformation_definition.fields

    fields            = transformation_definition_fields.where(kind: 'field')
    reject_conditions = transformation_definition_fields.where(kind: 'reject_if')
    delete_conditions = transformation_definition_fields.where(kind: 'delete_if')

    Transformation::Execution.new(@transformation_job.records(page), fields, reject_conditions, delete_conditions).call
  end

  def queue_load_worker(records)
    load_job = LoadJob.create(harvest_job: @harvest_job, page: @transformation_job.page,
                              api_record_id: @transformation_job.api_record_id)

    LoadWorker.perform_async(load_job.id, records.to_json)
  end

  def queue_delete_worker(records)
    delete_job = DeleteJob.create(harvest_job: @harvest_job, page: @transformation_job.page)

    DeleteWorker.perform_async(delete_job.id, records.to_json)
  end

  def update_transformation_report(valid_records, rejected_records, deleted_records)
    @transformation_job.reload
    records_count = @transformation_job.records_transformed + valid_records.count
    rejected_records_count = @transformation_job.records_rejected + rejected_records.count
    deleted_records_count = @transformation_job.records_deleted + deleted_records.count

    @transformation_job.update(records_transformed: records_count, records_rejected: rejected_records_count,
                               records_deleted: deleted_records_count)
  end
end
