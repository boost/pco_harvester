# frozen_string_literal: true

class HarvestWorker < ApplicationWorker
  def child_perform(harvest_job)
    @harvest_job = harvest_job
    @pipeline_job = harvest_job.pipeline_job

    @harvest_report = HarvestReport.create(pipeline_job: @pipeline_job, harvest_job: @harvest_job,
                                           kind: @harvest_job.harvest_definition.kind)

    if @pipeline_job.extraction_job.nil? || @harvest_job.harvest_definition.enrichment?
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

    ExtractionWorker.perform_async(extraction_job.id, @harvest_report.id)
  end

  def create_transformation_jobs
    extraction_job = @pipeline_job.extraction_job
    @harvest_job.update(extraction_job_id: extraction_job.id)
    @harvest_report.extraction_completed!

    (extraction_job.extraction_definition.page..extraction_job.documents.total_pages).each do |page|
      @pipeline_job.reload
      break if @pipeline_job.cancelled?

      @harvest_report.increment_pages_extracted!
      TransformationWorker.perform_async(@harvest_job.id, page)
      @harvest_report.increment_transformation_workers_queued!
    end
  end
end
