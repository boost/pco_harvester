# frozen_string_literal: true

class TransformationWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(extraction_job_id, transformation_definition_id, harvest_job_id, page, api_record_id = nil)
    @extraction_job = ExtractionJob.find(extraction_job_id)
    @transformation_definition = TransformationDefinition.find(transformation_definition_id)
    @harvest_job = HarvestJob.find(harvest_job_id)
    @harvest_report = @harvest_job.harvest_report
    @page = page
    @api_record_id = api_record_id

    job_start

    transformed_records = transform_records(page).map(&:to_hash)

    valid_records       = transformed_records.select do |record|
      record['rejection_reasons'].blank? && record['deletion_reasons'].blank?
    end
    rejected_records    = transformed_records.select { |record| record['rejection_reasons'].present? }
    deleted_records     = transformed_records.select { |record| record['deletion_reasons'].present? }

    @harvest_report.increment_records_transformed!(valid_records.count)
    @harvest_report.increment_records_rejected!(rejected_records.count)
    @harvest_report.update(transformation_updated_time: Time.zone.now)

    queue_load_worker(valid_records) if valid_records.any?
    queue_delete_worker(deleted_records) if deleted_records.any?

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
    transformation_definition_fields = @transformation_definition.fields

    fields            = transformation_definition_fields.where(kind: 'field')
    reject_conditions = transformation_definition_fields.where(kind: 'reject_if')
    delete_conditions = transformation_definition_fields.where(kind: 'delete_if')

    Transformation::Execution.new(records(page), fields, reject_conditions, delete_conditions).call
  end

  def queue_load_worker(records)
    LoadWorker.perform_async(@harvest_job.id, records.to_json, @api_record_id)
    @harvest_report.increment_load_workers_queued!
  end

  def queue_delete_worker(records)
    DeleteWorker.perform_async(records.to_json, @harvest_job.pipeline_job.destination.id, @harvest_report.id)
    @harvest_report.increment_delete_workers_queued!
  end

  def records(page = 1)
    return [] if @transformation_definition.record_selector.blank? || @extraction_job.documents[page].nil?

    case @transformation_definition.extraction_job.format
    when 'HTML'
      Nokogiri::HTML(@extraction_job.documents[page].body)
              .xpath(@transformation_definition.record_selector)
              .map(&:to_xml)
    when 'XML'
      Nokogiri::XML(@extraction_job.documents[page].body)
              .xpath(@transformation_definition.record_selector)
              .map(&:to_xml)
    when 'JSON'
      JsonPath.new(@transformation_definition.record_selector)
              .on(@extraction_job.documents[page].body)
              .flatten
    end
  end
end
