module JobsHelper
  # Returns the human readable text for the status of a given job
  #
  # @return String
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
    end
  end
end
