# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(*args)
    @job = find_job(args[0])
    job_start
    child_perform(@job, *args[1..])
    job_end
  end

  protected

  def find_job(job_id)
    job_class = self.class.name.gsub('Worker', 'Job').constantize
    job_class.find(job_id)
  end

  def job_start
    @job.running!
    @job.update(start_time: Time.zone.now) if @job.start_time.blank?
  end

  def job_end
    @job.completed! unless @job.cancelled?
    @job.update(end_time: Time.zone.now)
  end
end
