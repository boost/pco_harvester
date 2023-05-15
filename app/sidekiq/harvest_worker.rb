# frozen_string_literal: true

class HarvestWorker
  include Sidekiq::Job

  def perform(harvest_job_id)
    @harvest_job = HarvestJob.find(harvest_job_id)
    @harvest_definition = @harvest_job.harvest_definition

    # This will be optional depending on if the user has decided to use an existing job result
    # or wants to pull a fresh data set
    @extraction_job = ExtractionJob.new(extraction_definition: @harvest_definition.extraction_definition, kind: 'sample')
    @extraction_job.running!
    @extraction_job.update(start_time: Time.zone.now)

    Extraction::Execution.new(@extraction_job, @extraction_job.extraction_definition).call

    @extraction_job.completed! unless @extraction_job.cancelled?
    @extraction_job.update(end_time: Time.zone.now)

    @transformation = TransformationDefinition.new(
      @harvest_definition.transformation_definition.attributes.merge('extraction_job_id' => @extraction_job.id)
    )

    transformed_records = Transformation::Execution.new(@transformation.records, @transformation.fields).call

    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, @harvest_definition.destination).call
    end

    Sidekiq.logger.info 'Complete'
  end
end
