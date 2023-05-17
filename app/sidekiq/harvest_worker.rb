# frozen_string_literal: true

class HarvestWorker < ApplicationWorker
  def child_perform(harvest_job, extraction_job_id)
    @harvest_job = harvest_job

    if extraction_job_id.nil?
      create_extraction_job
    else
      create_transformation_jobs(extraction_job_id)
    end
  end

  def create_extraction_job
    extraction_job = ExtractionJob.create(
      extraction_definition: @harvest_job.extraction_definition,
      harvest_job: @harvest_job,
      kind: 'full'
    )
    ExtractionWorker.perform_async(extraction_job.id)
  end

  def create_transformation_jobs(extraction_job_id)
    extraction_job = ExtractionJob.find(extraction_job_id)

    (extraction_job.extraction_definition.page..extraction_job.documents.total_pages).each do |page|
      transformation_job = TransformationJob.create(
        transformation_definition: @harvest_job.transformation_definition,
        harvest_job: @harvest_job,
        page:
      )
      TransformationWorker.perform_async(transformation_job.id)
    end
  end
end
