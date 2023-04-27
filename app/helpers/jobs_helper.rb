module JobsHelper
  def job_status_text(job)
    if job.queued?
      'Waiting in queue...'
    elsif job.running?
      "Running #{job.kind} job..."
    elsif job.errored?
      'An error occured'
    elsif job.cancelled?
      'Cancelled'
    elsif job.completed?
      'Completed'
    else
      raise ArgumentError, 'Unknown job status'
    end
  end
end
