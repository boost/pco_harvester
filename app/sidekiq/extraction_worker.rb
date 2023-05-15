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

  def perform(job_id)
    @extraction_job = ExtractionJob.find(job_id)
    @extraction_job.running!
    @extraction_job.update(start_time: Time.zone.now)

    Extraction::Execution.new(@extraction_job, @extraction_job.extraction_definition).call

    @extraction_job.completed! unless @extraction_job.cancelled?
    @extraction_job.update(end_time: Time.zone.now)
  end
end
