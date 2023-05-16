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
      de = DocumentExtraction.new(@extraction_definition, @extraction_job.extraction_folder)
      de.extract_and_save

      enqueue_record_transformation if @harvest_job.present?

      return if @extraction_job.is_sample?

      total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.document.body).first.to_i
      max_pages       = (total_results / @extraction_definition.per_page) + 1

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1
        de.extract_and_save

        enqueue_record_transformation if @harvest_job.present?

        sleep @extraction_definition.throttle / 1000.0
        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end

    def enqueue_record_transformation
      TransformationWorker.perform_async(@harvest_job.transformation_job.id, @extraction_definition.page)
    end
  end
end
