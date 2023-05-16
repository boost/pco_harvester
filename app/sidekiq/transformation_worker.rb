# frozen_string_literal: true

class TransformationWorker
  include Sidekiq::Job

  def perform(transformation_job_id, page)
    @transformation_job = TransformationJob.find(transformation_job_id)
    @transformation_job.running!
    @transformation_job.update(start_time: Time.zone.now) unless @transformation_job.start_time.present?

    @harvest_job = @transformation_job.harvest_job

    transformation = if @harvest_job.present?
                       TransformationDefinition.new(
                         @harvest_job.transformation_definition.attributes.merge(
                           'extraction_job_id' => @harvest_job.extraction_job.id
                         )
                       )
                     else
                       TransformationDefinition.find(@transformation_job.transformation_definition_id)
                     end

    transformed_records = Transformation::Execution.new(transformation.records(page), transformation.fields).call

    @transformation_job.completed!
    records_count = @transformation_job.records_transformed + transformed_records.count

    @transformation_job.update(end_time: Time.zone.now, records_transformed: records_count)

    LoadWorker.perform_async(@harvest_job.load_job.id, @harvest_job.id, transformed_records.map(&:to_hash))
  end
end
