module JobsHelper
  def job_status_text(job)
    if job.queued?
      'Queued...'
    elsif job.running?
      "Running #{job.kind} job..."
    elsif job.errored?
      'An error occured'
    elsif job.cancelled?
      'Cancelled'
    elsif job.completed?
      'Completed'
    end
  end
end
