# frozen_string_literal: true

class ExtractionWorker < ApplicationWorker
  sidekiq_retries_exhausted do |job, _ex|
    @job = ExtractionJob.find(job['args'].first)
    @job.errored!
    @job.update(error_message: job['error_message'])
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def child_perform(extraction_job)
    if extraction_job.extraction_definition.enrichment?
      Extraction::EnrichmentExecution.new(extraction_job).call
    else
      Extraction::Execution.new(extraction_job, extraction_job.extraction_definition).call
    end
  end

  def job_start
    super

    return if @harvest_report.blank?

    @harvest_report.extraction_running!
  end

  def job_end
    super

    return if @harvest_report.blank?

    @harvest_report.reload

    @harvest_report.extraction_completed! unless @harvest_report.extraction_cancelled?

    @harvest_report.transformation_completed! if @harvest_report.transformation_workers_completed?

    @harvest_report.load_completed! if @harvest_report.load_workers_completed?

    @harvest_report.delete_completed! if @harvest_report.delete_workers_completed?

    @harvest_report.pipeline_job.enqueue_enrichment_jobs(@harvest_report.harvest_job.name)
  end
end
