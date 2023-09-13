# frozen_string_literal: true

module JobsHelper
  STATUS_TO_TEXT = {
    'queued' => 'Waiting in queue...',
    'running' => 'Running...',
    'errored' => 'An error occured',
    'cancelled' => 'Cancelled',
    'completed' => 'Completed'
  }.freeze

  # Returns the human readable text for the status of a given job
  #
  # @return String
  def job_status_text(job)
    return "Running #{job.kind} job..." if job.running? && job.instance_of?(ExtractionJob)

    STATUS_TO_TEXT[job.status]
  end

  def job_start_time(job)
    job.start_time.present? ? job.start_time.to_fs(:light) : '-'
  end

  def job_end_time(job)
    job.end_time.present? ? job.end_time.to_fs(:light) : '-'
  end

  def job_duration(job)
    job_duration_seconds(job.duration_seconds)
  end

  def job_duration_seconds(seconds)
    return '-' if seconds.nil?

    ActiveSupport::Duration.build(seconds).inspect
  end
end
