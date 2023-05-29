# frozen_string_literal: true

class TransformationWorker < ApplicationWorker
  def child_perform(transformation_job)
    @transformation_job = transformation_job
    @harvest_job = @transformation_job.harvest_job

    transformed_records = transform_records(transformation_job.page)
    queue_load_worker(transformed_records)

    update_transformation_report(transformed_records)
  end

  def transform_records(page)
    transformation_definition = @transformation_job.transformation_definition
    Transformation::Execution.new(@transformation_job.records(page), transformation_definition.fields).call
  end

  def queue_load_worker(transformed_records)
    load_job = LoadJob.create(harvest_job: @harvest_job, page: @transformation_job.page,
                              api_record_id: @transformation_job.api_record_id)
    LoadWorker.perform_async(load_job.id, transformed_records.map(&:to_hash).to_json)
  end

  def update_transformation_report(transformed_records)
    @transformation_job.reload
    records_count = @transformation_job.records_transformed + transformed_records.count
    @transformation_job.update(records_transformed: records_count)
  end
end
