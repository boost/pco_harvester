# frozen_string_literal: true

class LoadWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(harvest_job_id, records, api_record_id = nil)
    @harvest_job = HarvestJob.find(harvest_job_id)
    @harvest_report = @harvest_job.harvest_report

    job_start

    transformed_records = JSON.parse(records)

    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, @harvest_job, api_record_id).call
      @harvest_report.increment_records_loaded!
      @harvest_report.update(load_updated_time: Time.zone.now)
    end

    job_end
  end

  def job_start
    @harvest_report.load_running!
  end

  def job_end
    @harvest_report.increment_load_workers_completed!

    @harvest_report.load_completed! if @harvest_report.load_workers_completed?

    @harvest_job.pipeline_job.enqueue_enrichment_jobs(@harvest_job.name)
  end
end
