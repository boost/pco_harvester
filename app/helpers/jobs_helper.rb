module JobsHelper
  def job_status_text(job)
    if job.queued?
      'Queued...'
    elsif job.running?
      'Running full job...'
    elsif job.errored?
      'An error occured...'
    elsif job.completed?
      'Completed'
    end
  end
end
