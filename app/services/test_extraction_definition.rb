class TestExtractionDefinition
  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
  end

  def call
    Faraday.new(url:, params:, headers:) do |f|
      f.use FaradayMiddleware::FollowRedirects, limit: 5
      f.adapter Faraday.default_adapter
    end.get
  end

  private

  def url
    @extraction_definition.base_url
  end

  def params
    {
      @extraction_definition.page_parameter => @extraction_definition.page,
      @extraction_definition.per_page_parameter => @extraction_definition.per_page
    }
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'User-Agent' => 'Supplejack Harvester v2.0'
    }
  end
end
