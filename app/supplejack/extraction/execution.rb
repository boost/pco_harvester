# frozen_string_literal: true

module Extraction
  # Performs the work as defined in the document extraction
  class Execution
    def initialize(job, extraction_definition)
      @extraction_job = job
      @extraction_definition = extraction_definition
      @harvest_job = @extraction_job.harvest_job
      @de = DocumentExtraction.new(@extraction_definition, @extraction_job.extraction_folder)
    end

    def call
      @de.extract_and_save

      enqueue_record_transformation

      return if @extraction_job.is_sample?

      max_pages = (total_results / @extraction_definition.per_page) + 1

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1
        @extraction_definition.token_value = next_token

        @de.extract_and_save

        # The throttle needs to be before the transformation jobs are enqueued
        # otherwise the child processes finish before the extraction process
        # and the enrichments are never queued.
        sleep @extraction_definition.throttle / 1000.0

        enqueue_record_transformation

        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end

    private

    def total_results
      if @extraction_definition.format == 'HTML'
        return Nokogiri::HTML(@de.document.body).xpath(@extraction_definition.total_selector).first.content.to_i
      end
      if @extraction_definition.format == 'XML'
        return Nokogiri::XML(@de.document.body).xpath(@extraction_definition.total_selector).first.content.to_i
      end

      JsonPath.new(@extraction_definition.total_selector).on(@de.document.body).first.to_i
    end

    def next_token
      return unless @extraction_definition.pagination_type == 'tokenised'
      if @extraction_definition.format == 'HTML'
        return Nokogiri::HTML(@de.document.body).xpath(@extraction_definition.next_token_path).first.content
      end
      if @extraction_definition.format == 'XML'
        return Nokogiri::XML(@de.document.body).xpath(@extraction_definition.next_token_path).first.content
      end

      JsonPath.new(@extraction_definition.next_token_path).on(@de.document.body).first
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
