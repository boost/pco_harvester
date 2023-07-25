module Extraction
  class EnrichmentExecution
    def initialize(extraction_job)
      @extraction_job = extraction_job
      @extraction_definition = extraction_job.extraction_definition
      @harvest_job = extraction_job.harvest_job
    end

    def call
      re = RecordExtraction.new(@extraction_definition, @extraction_definition.page, @harvest_job).extract

      max_pages = JsonPath.new(@extraction_definition.total_selector).on(re.body).first.to_i
      records = JSON.parse(re.body)['records']

      extract_and_save_enrichment_documents(records)

      return if @extraction_job.is_sample?

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1

        re = RecordExtraction.new(@extraction_definition, @extraction_definition.page, @harvest_job).extract
        records = JSON.parse(re.body)['records']

        extract_and_save_enrichment_documents(records)

        break if @extraction_job.cancelled?
      end
    end

    private

    def extract_and_save_enrichment_documents(records)
      records.each_with_index do |record, index|
        page = ((@extraction_definition.page - 1) * @extraction_definition.per_page) + (index + 1)

        ee = EnrichmentExtraction.new(@extraction_definition, record, page, @extraction_job.extraction_folder)

        ee.extract_and_save

        enqueue_record_transformation(record, ee.document, page)

        sleep @extraction_definition.throttle / 1000.0
        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end

    def enqueue_record_transformation(record, document, page)
      return unless @harvest_job.present? && document.successful?

      transformation_job = TransformationJob.create(
        extraction_job: @extraction_job,
        transformation_definition: @harvest_job.transformation_definition,
        harvest_job: @harvest_job,
        page:,
        api_record_id: record['id']
      )
      TransformationWorker.perform_async(transformation_job.id)
    end
  end
end
