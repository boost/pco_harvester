# frozen_string_literal: true

class ExtractionWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  sidekiq_retries_exhausted do |job, _ex|
    @extraction_job = ExtractionJob.find(job['args'].first)
    @extraction_job.errored!
    @extraction_job.update(error_message: job['error_message'])
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def perform(extraction_job_id, harvest_report_id = nil)
    @extraction_job = ExtractionJob.find(extraction_job_id)
    @harvest_report = HarvestReport.find(harvest_report_id) if harvest_report_id.present?

    job_start

    if @extraction_job.extraction_definition.enrichment?
      Extraction::EnrichmentExecution.new(@extraction_job).call
    else
      Extraction::Execution.new(@extraction_job, @extraction_job.extraction_definition).call
    end

    job_end
  end

  def job_start
    @extraction_job.running!

    return if @harvest_report.blank?

    @harvest_report.extraction_running!
  end

  def job_end
    @extraction_job.completed! unless @extraction_job.cancelled?

    return if @harvest_report.blank?

    @harvest_report.extraction_completed! unless @harvest_report.extraction_cancelled?

    @harvest_report.transformation_completed! if @harvest_report.transformation_workers_completed?

    @harvest_report.load_completed! if @harvest_report.load_workers_completed?

    @harvest_report.delete_completed! if @harvest_report.delete_workers_completed?

    @harvest_report.pipeline_job.enqueue_enrichment_jobs(@harvest_report.harvest_job.name)
  end
end
