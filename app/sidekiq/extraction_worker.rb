# frozen_string_literal: true

class ExtractionWorker < ApplicationWorker
  sidekiq_retries_exhausted do |job, _ex|
    @extraction_job = ExtractionJob.find(job['args'].first)
    @extraction_job.errored!
    @extraction_job.update(error_message: job['error_message'])
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def job_start
    if @harvest_report
      @harvest_report.extraction_running!
      @harvest_report.update(extraction_start_time: Time.zone.now) if @harvest_report.extraction_start_time.blank?
    end

    super
  end

  def child_perform(extraction_job)
    return Extraction::EnrichmentExecution.new(extraction_job).call if extraction_job.extraction_definition.enrichment?

    Extraction::Execution.new(extraction_job, extraction_job.extraction_definition).call
  end

  def job_end
    if @harvest_report
      @harvest_report.extraction_completed! unless @harvest_report.extraction_cancelled?
      @harvest_report.update(extraction_end_time: Time.zone.now) if @harvest_report.extraction_end_time.blank?

      if @harvest_report.transformation_workers_queued == @harvest_report.transformation_workers_completed
        @harvest_report.transformation_completed!
        @harvest_report.update(transformation_end_time: Time.zone.now)

        if @harvest_report.load_workers_queued == @harvest_report.load_workers_completed
          @harvest_report.load_completed!
          @harvest_report.update(load_end_time: Time.zone.now)
        end
        
        if @harvest_report.delete_workers_queued == @harvest_report.delete_workers_completed
          @harvest_report.delete_completed!
          @harvest_report.update(delete_end_time: Time.zone.now)
        end
      end
    end

    @harvest_report.pipeline_job.enqueue_enrichment_jobs(@harvest_report.harvest_job.name) if @harvest_report.present?

    super
  end
end
