# frozen_string_literal: true

module Extraction
  class EnrichmentExecution
    def initialize(extraction_job)
      @extraction_job = extraction_job
      @extraction_definition = extraction_job.extraction_definition
      @harvest_job = extraction_job.harvest_job
    end

    def call
      EnrichmentIterator.new(@extraction_job).each do |api_document, page|
        @extraction_definition.page = page
        api_records = JSON.parse(api_document.body)['records']
        extract_and_save_enrichment_documents(api_records)
      end
    end

    private

    def extract_and_save_enrichment_documents(api_records)
      api_records.each_with_index do |api_record, index|
        page = ((@extraction_definition.page - 1) * @extraction_definition.per_page) + (index + 1)

        ee = EnrichmentExtraction.new(@extraction_definition, api_record, page, @extraction_job.extraction_folder)

        next unless ee.valid?

        ee.extract_and_save

        enqueue_record_transformation(api_record, ee.document, page)

        sleep @extraction_definition.throttle / 1000.0
        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
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
