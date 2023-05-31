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

      enqueue_record_transformation(de.document)

      return if @extraction_job.is_sample?

      total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.document.body).first.to_i
      max_pages       = (total_results / @extraction_definition.per_page) + 1

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1
        de.extract_and_save

        enqueue_record_transformation(de.document)

        sleep @extraction_definition.throttle / 1000.0
        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end

    private

    def enqueue_record_transformation(document)
      return unless @harvest_job.present? && document.successful?

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
