# frozen_string_literal: true

class HarvestWorker
  include Sidekiq::Job

  def perform(harvest_job_id)
    @harvest_job        = HarvestJob.find(harvest_job_id)
    @extraction_job     = ExtractionJob.create(extraction_definition: @harvest_job.extraction_definition,
                                               harvest_job: @harvest_job, kind: 'full')
    @transformation_job = TransformationJob.create(transformation_definition: @harvest_job.transformation_definition,
                                                   harvest_job: @harvest_job)
    @load_job           = LoadJob.create(harvest_job: @harvest_job)

    ExtractionWorker.perform_async(@extraction_job.id)
  end
end
