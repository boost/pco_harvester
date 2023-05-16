# frozen_string_literal: true

class TransformationWorker < ApplicationWorker
  def child_perform(transformation_job)
    @transformation_job = transformation_job
    @harvest_job = @transformation_job.harvest_job

    transformed_records = transform_records(transformation_job.page)
    queue_load_worker(transformed_records)

    update_transformation_report(transformed_records)
  end

  def find_transformation_definition
    if @harvest_job.present?
      TransformationDefinition.new(
        @harvest_job.transformation_definition.attributes.merge(
          'extraction_job_id' => @harvest_job.extraction_job.id
        )
      )
    else
      TransformationDefinition.find(@transformation_job.transformation_definition_id)
    end
  end

  def transform_records(page)
    transformation = find_transformation_definition
    Transformation::Execution.new(transformation.records(page), transformation.fields).call
  end

  def queue_load_worker(transformed_records)
    load_job = LoadJob.create(harvest_job: @harvest_job, page: @transformation_job.page)
    LoadWorker.perform_async(load_job.id, transformed_records.map(&:to_hash).to_json)
  end

  def update_transformation_report(transformed_records)
    @transformation_job.reload
    records_count = @transformation_job.records_transformed + transformed_records.count
    @transformation_job.update(records_transformed: records_count)
  end
end
