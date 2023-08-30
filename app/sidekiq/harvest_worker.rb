# frozen_string_literal: true

class HarvestWorker < ApplicationWorker
  def child_perform(harvest_job)
    @harvest_job = harvest_job
    @pipeline_job = harvest_job.pipeline_job

    HarvestReport.create(pipeline_job: @pipeline_job, harvest_job: @harvest_job)

    if @pipeline_job.extraction_job.nil?
      create_extraction_job
    else
      create_transformation_jobs
    end
  end

  def create_extraction_job
    extraction_job = ExtractionJob.create(
      extraction_definition: @harvest_job.extraction_definition,
      harvest_job: @harvest_job
    )

    ExtractionWorker.perform_async(extraction_job.id)
  end

  def create_transformation_jobs
    extraction_job = @harvest_job.extraction_job

    (extraction_job.extraction_definition.page..extraction_job.documents.total_pages).each do |page|
      transformation_job = TransformationJob.create(
        extraction_job:,
        transformation_definition: @harvest_job.transformation_definition,
        harvest_job: @harvest_job,
        page:
      )
      TransformationWorker.perform_async(transformation_job.id)
    end
  end
end
