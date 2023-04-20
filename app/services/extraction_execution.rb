class ExtractionExecution
  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
  end

  def call
    de = DocumentExtraction.new(@extraction_definition)
    de.extract_and_save
    total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.document.body).first.to_i
    max_pages       = (total_results / @extraction_definition.per_page) + 1

    (@extraction_definition.page...max_pages).each do
      @extraction_definition.page += 1
      de.extract_and_save

      sleep @extraction_definition.throttle
      break if @extraction_definition.page > 3
    end
  end
end
