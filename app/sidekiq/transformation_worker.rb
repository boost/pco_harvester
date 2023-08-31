# frozen_string_literal: true

class TransformationWorker < ApplicationWorker
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
    
    # queue_load_worker(valid_records)
    # queue_delete_worker(deleted_records) unless deleted_records.empty?

    job_end
  end

  def job_start
    @harvest_report.transformation_running!
    @harvest_report.update(transformation_start_time: Time.zone.now) if @harvest_report.transformation_start_time.blank?
  end

  def job_end
    @harvest_report.increment_transformation_workers_completed!
  end

  def transform_records(page)
    transformation_definition_fields = @transformation_definition.fields

    fields            = transformation_definition_fields.where(kind: 'field')
    reject_conditions = transformation_definition_fields.where(kind: 'reject_if')
    delete_conditions = transformation_definition_fields.where(kind: 'delete_if')

    Transformation::Execution.new(records(page), fields, reject_conditions, delete_conditions).call
  end

  def queue_load_worker(records)
    load_job = LoadJob.create(harvest_job: @harvest_job, page: @page,
                              api_record_id: @api_record_id)

    LoadWorker.perform_async(load_job.id, records.to_json)
  end

  def queue_delete_worker(records)
    delete_job = DeleteJob.create(harvest_job: @harvest_job, page: @transformation_job.page)

    DeleteWorker.perform_async(delete_job.id, records.to_json)
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
