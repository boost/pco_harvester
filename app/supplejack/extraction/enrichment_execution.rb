# frozen_string_literal: true

module Extraction
  class EnrichmentExecution
    def initialize(extraction_job)
      @extraction_job = extraction_job
      @extraction_definition = extraction_job.extraction_definition
      @harvest_job = extraction_job.harvest_job
    end

    def call
      SjApiEnrichmentIterator.new(@extraction_job).each do |api_document, page|
        @extraction_definition.page = page
        api_records = JSON.parse(api_document.body)['records']
        extract_and_save_enrichment_documents(api_records)
      end
    end

    private

    def extract_and_save_enrichment_documents(api_records)
      api_records.each_with_index do |api_record, index|
        page = page_from_index(index)

        ee = new_enrichment_extraction(api_record, page)
        next unless ee.valid?

        ee.extract_and_save
        enqueue_record_transformation(api_record, ee.document, page)

        throttle
        break if @extraction_job.reload.cancelled?
      end
    end

    def throttle
      sleep @extraction_definition.throttle / 1000.0
    end

    def page_from_index(index)
      ((@extraction_definition.page - 1) * @extraction_definition.per_page) + (index + 1)
    end

    def new_enrichment_extraction(api_record, page)
      EnrichmentExtraction.new(@extraction_definition, api_record, page, @extraction_job.extraction_folder)
    end

    def enqueue_record_transformation(api_record, document, page)
      return unless @harvest_job.present? && document.successful?

      transformation_job = TransformationJob.create(
        extraction_job: @extraction_job,
        transformation_definition: @harvest_job.transformation_definition,
        harvest_job: @harvest_job,
        page:,
        api_record_id: api_record['id']
      )
      TransformationWorker.perform_async(transformation_job.id, api_record)
    end
  end
end
