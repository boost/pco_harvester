class ExtractionJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  sidekiq_retries_exhausted do |job, _ex|
    @job = Job.find(job['args'].first)
    @job.mark_as_errored
    Sidekiq.logger.warn "Failed #{job['class']} with #{job['args']}: #{job['error_message']}"
  end

  def perform(job_id)
    @job = Job.find(job_id)
    @job.mark_as_running

    ExtractionExecution.new(@job, @job.extraction_definition).call

    @job.mark_as_completed
  end
end
