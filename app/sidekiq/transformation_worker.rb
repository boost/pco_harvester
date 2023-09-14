# frozen_string_literal: true

class TransformationWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(extraction_job_id, harvest_job_id, page, api_record_id = nil)
    @extraction_job = ExtractionJob.find(extraction_job_id)
    @harvest_job = HarvestJob.find(harvest_job_id)
    @transformation_definition = TransformationDefinition.find(@harvest_job.transformation_definition.id)
    @harvest_report = @harvest_job.harvest_report
    @page = page
    @api_record_id = api_record_id

    job_start

    transformed_records = transform_records(page).map(&:to_hash)

    valid_records       = select_valid_records(transformed_records)
    rejected_records    = transformed_records.select { |record| record['rejection_reasons'].present? }
    deleted_records     = transformed_records.select { |record| record['deletion_reasons'].present? }

    @harvest_report.increment_records_transformed!(valid_records.count)
    @harvest_report.increment_records_rejected!(rejected_records.count)
    @harvest_report.update(transformation_updated_time: Time.zone.now)

    queue_load_worker(valid_records)
    queue_delete_worker(deleted_records)

    job_end
  end

  def job_start
    @harvest_report.transformation_running!
  end

  def job_end
    @harvest_report.increment_transformation_workers_completed!
    @harvest_report.reload

    return unless @harvest_report.transformation_workers_completed?

    @harvest_report.transformation_completed!

    return unless @harvest_report.delete_workers_queued.zero?

    @harvest_report.delete_completed!
  end

  def transform_records(page)
    Transformation::Execution.new(
      records(page),
      @transformation_definition.fields
    ).call
  end

  def queue_load_worker(records)
    return if records.empty?

    LoadWorker.perform_async(@harvest_job.id, records.to_json, @api_record_id)
    @harvest_report.increment_load_workers_queued!
  end

  def queue_delete_worker(records)
    return if records.empty?

    DeleteWorker.perform_async(records.to_json, @harvest_job.pipeline_job.destination.id, @harvest_report.id)
    @harvest_report.increment_delete_workers_queued!
  end

  def records(page = 1)
    Transformation::RawRecordsExtractor.new(@transformation_definition, @extraction_job).records(page)
  end

  def select_valid_records(records)
    records.select do |record|
      record['rejection_reasons'].blank? && record['deletion_reasons'].blank?
    end
  end
end
