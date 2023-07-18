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
      harvest_job.pipeline.enrichments.each do |enrichment|
        harvest_key = harvest_job.key
        if harvest_job.key.include?('__')
          harvest_key = harvest_key.match(/(?<key>.+)__/)[:key]
        end

        next if HarvestJob.find_by(key: "#{harvest_key}__enrichment-#{enrichment.id}").present?

        enrichment_job = HarvestJob.create(
          harvest_definition_id: enrichment.id,
          destination_id: harvest_job.destination.id,
          key: "#{harvest_key}__enrichment-#{enrichment.id}"
        )

        HarvestWorker.perform_async(enrichment_job.id)
      end
    end
  end
end
