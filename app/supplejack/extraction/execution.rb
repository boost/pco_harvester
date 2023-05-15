# frozen_string_literal: true

module Extraction
  # Performs the work as defined in the document extraction
  class Execution
    def initialize(job, extraction_definition)
      @extraction_job = job
      @extraction_definition = extraction_definition
    end

    def call
      de = DocumentExtraction.new(@extraction_definition, @extraction_job.extraction_folder)
      de.extract_and_save
      return if @extraction_job.is_sample?

      total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.document.body).first.to_i
      max_pages       = (total_results / @extraction_definition.per_page) + 1

      (@extraction_definition.page...max_pages).each do
        @extraction_definition.page += 1
        de.extract_and_save

        sleep @extraction_definition.throttle / 1000.0
        @extraction_job.reload

        if @extraction_job.cancelled?
          @extraction_job.update(end_time: Time.zone.now)
          break
        end
      end
    end
  end
end
