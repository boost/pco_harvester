class ExtractionExecution
  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
  end

  def call
    p "Fetching from page #{@extraction_definition.page}"
    de = DocumentExtraction.new(@extraction_definition)
    de.extract_and_save
    total_results   = JsonPath.new(@extraction_definition.total_selector).on(de.response.body).first.to_i
    max_pages       = (total_results / @extraction_definition.per_page) + 1

    (@extraction_definition.page...max_pages).each do
      @extraction_definition.page += 1
      de.extract_and_save

      sleep @extraction_definition.throttle
      break if @extraction_definition.page > 3
    end
  end
end
