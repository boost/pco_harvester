# frozen_string_literal: true

module Extraction
  # Performs the work as defined in the document extraction
  class Execution
    def initialize(job, extraction_definition)
      @extraction_job = job
      @extraction_definition = extraction_definition
      @harvest_job = @extraction_job.harvest_job
    end

    def call
      extract_and_save_document(@extraction_definition.requests.first)

      return if @extraction_job.is_sample?
      return unless @extraction_definition.paginated?

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1

        extract_and_save_document(@extraction_definition.requests.last)

        sleep @extraction_definition.throttle / 1000.0

        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end

    private

    def extract_and_save_document(request)
      @de = DocumentExtraction.new(request, @extraction_job.extraction_folder, @previous_request)
      @previous_request = @de.extract
      @de.save

      enqueue_record_transformation
    end

    def max_pages
      return @harvest_job.pages if @harvest_job.present? && @harvest_job.set_number?

      (total_results / @extraction_definition.per_page) + 1
    end

    def total_results
      if @extraction_definition.format == 'HTML'
        return Nokogiri::HTML(@de.document.body).xpath(@extraction_definition.total_selector).first.content.to_i
      end
      if @extraction_definition.format == 'XML'
        return Nokogiri::XML(@de.document.body).xpath(@extraction_definition.total_selector).first.content.to_i
      end

      JsonPath.new(@extraction_definition.total_selector).on(@de.document.body).first.to_i
    end

    def enqueue_record_transformation
      return unless @harvest_job.present? && @de.document.successful?

      transformation_job = TransformationJob.create(
        extraction_job: @extraction_job,
        transformation_definition: @harvest_job.transformation_definition,
        harvest_job: @harvest_job,
        page: @extraction_definition.page
      )
      TransformationWorker.perform_async(transformation_job.id)
    end
  end
end
