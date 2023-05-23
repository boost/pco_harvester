# frozen_string_literal: true

class ExtractionWorker < ApplicationWorker
  sidekiq_retries_exhausted do |job, _ex|
    @extraction_job = ExtractionJob.find(job['args'].first)
    @extraction_job.errored!
    @extraction_job.update(error_message: job['error_message'])
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def child_perform(extraction_job)
    return Extraction::EnrichmentExecution.new(extraction_job).call if extraction_job.enrichment?

    Extraction::Execution.new(extraction_job, extraction_job.extraction_definition).call
  end
end
