# frozen_string_literal: true

module Extraction
  # Performs the work as defined in the document extraction
  class Execution
    def initialize(job, extraction_definition)
      @extraction_job = job
      @extraction_definition = extraction_definition
      @harvest_job = @extraction_job.harvest_job
      @harvest_report = @harvest_job.harvest_report if @harvest_job.present?
    end

    def call
      extract_and_save_document(@extraction_definition.requests.first)

      return if @extraction_job.is_sample?
      return unless @extraction_definition.paginated?

      loop do
        @extraction_definition.page += 1

        extract_and_save_document(@extraction_definition.requests.last)

        throttle

        break if @extraction_job.reload.cancelled?
        break if stop_condition_met?
      end
    end

    private

    def stop_condition_met?
      [set_number_reached?, extraction_failed?, duplicate_document_extracted?].any?(true)
    end

    def set_number_reached?
      return false unless @harvest_job.present? && @harvest_job.pipeline_job.set_number?

      @harvest_job.pipeline_job.pages == @extraction_definition.page
    end

    def extraction_failed?
      @de.document.status >= 400 || @de.document.status < 200
    end

    def duplicate_document_extracted?
      previous_page = @extraction_definition.page - 1
      previous_document = Extraction::Documents.new(@extraction_job.extraction_folder)[previous_page]

      return false if previous_document.nil?

      previous_document.body == @de.document.body
    end

    def throttle
      sleep @extraction_definition.throttle / 1000.0
    end

    def extract_and_save_document(request)
      @de = DocumentExtraction.new(request, @extraction_job.extraction_folder, @previous_request)
      @previous_request = @de.extract

      return if duplicate_document_extracted?

      @de.save

      if @harvest_report.present?
        @harvest_report.increment_pages_extracted!
        @harvest_report.update(extraction_updated_time: Time.zone.now)
      end

      enqueue_record_transformation
    end

    def enqueue_record_transformation
      return unless @harvest_job.present? && @de.document.successful?

      TransformationWorker.perform_async(@extraction_job.id, @harvest_job.id, @extraction_definition.page)
      @harvest_report.increment_transformation_workers_queued!
    end
  end
end
