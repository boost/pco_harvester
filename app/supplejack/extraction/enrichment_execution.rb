# frozen_string_literal: true

module Extraction
  class EnrichmentExecution
    def initialize(extraction_job)
      @extraction_job = extraction_job
      @extraction_definition = extraction_job.extraction_definition
      @harvest_job = extraction_job.harvest_job
    end

    def call
      re = RecordExtraction.new(@extraction_definition, @extraction_definition.page, @harvest_job).extract

      api_records = JSON.parse(re.body)['records']

      extract_and_save_enrichment_documents(api_records)

      return if @extraction_job.is_sample?

      (@extraction_definition.page...max_pages(re)).each do
        @extraction_definition.page += 1

        re = RecordExtraction.new(@extraction_definition, @extraction_definition.page, @harvest_job).extract
        api_records = JSON.parse(re.body)['records']

        extract_and_save_enrichment_documents(api_records)

        break if @extraction_job.cancelled?
      end
    end

    private

    def max_pages(record_extraction)
      return @harvest_job.pages if @harvest_job.present? && @harvest_job.set_number?

      JsonPath.new(@extraction_definition.total_selector).on(record_extraction.body).first.to_i
    end

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
