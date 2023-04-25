class ExtractionExecution
  def initialize(job, extraction_definition)
    @job = job
    @extraction_definition = extraction_definition
  end

  def call
    de = DocumentExtraction.new(@extraction_definition, @job.extraction_folder)
    de.extract_and_save
    total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.document.body).first.to_i
    max_pages       = (total_results / @extraction_definition.per_page) + 1

    (@extraction_definition.page...max_pages).each do
      @extraction_definition.page += 1
      de.extract_and_save

      sleep @extraction_definition.throttle / 1000.0
      break if @extraction_definition.page > 3
    end
  end
end
