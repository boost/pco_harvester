# frozen_string_literal: true

class LoadWorker < ApplicationWorker
  def child_perform(load_job, transformed_records)
    transformed_records = JSON.parse(transformed_records)

    sent_records = 0
    transformed_records.each do |transformed_record|
      Load::Execution.new(transformed_record, load_job).call
      sent_records += 1
    end

    update_load_report(load_job, sent_records)
  end

  def update_load_report(load_job, sent_records)
    load_job.reload
    load_job.update(records_loaded: load_job.records_loaded + sent_records)
  end

  def job_end
    super

    harvest_job = @job.harvest_job

    harvest_job.extraction_job.reload && harvest_job.transformation_jobs.each(&:reload) && harvest_job.load_jobs.each(&:reload)
  
    Sidekiq.logger.info "Harvest Job Extraction Status: #{harvest_job.extraction_job.status}"
    Sidekiq.logger.info "Harvest Job Transformation Status: #{harvest_job.transformation_jobs.map(&:status).uniq}"
    Sidekiq.logger.info "Harvest Job Load Status: #{harvest_job.load_jobs.map(&:status).uniq}"

    if harvest_job.extraction_job.completed? && harvest_job.transformation_jobs.all?(&:completed?) && harvest_job.load_jobs.all?(&:completed?)
      Sidekiq.logger.info '!! ENQUEUE THE ENRICHMENTS !!'
    end
  end
end
