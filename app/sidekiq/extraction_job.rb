# frozen_string_literal: true

class ExtractionJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  sidekiq_retries_exhausted do |job, _ex|
    @job = Job.find(job['args'].first)
    @job.errored!
    @job.update(error_message: job['error_message'])
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def perform(job_id)
    @job = Job.find(job_id)
    @job.running!
    @job.update(start_time: Time.zone.now)

    Extraction::Execution.new(@job, @job.extraction_definition).call

    @job.completed! unless @job.cancelled?
    @job.update(end_time: Time.zone.now)
  end
end
