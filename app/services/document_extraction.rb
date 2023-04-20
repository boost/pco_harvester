class DocumentExtraction
  EXTRACTION_FOLDER = "#{Rails.root}/extractions/".freeze

  attr_reader :request

  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
  end

  def extract
    p "Fetching from page #{@extraction_definition.page}"
    @request = Request.new(url:, params:, headers:).get
  end

  def save
    File.write(request_path, @request.to_json)
  end

  def extract_and_save
    extract
    save
  end

  private

  def request_path
    page_str = format('%05d', @extraction_definition.page)[-5..]
    name_str = @extraction_definition.name.parameterize(separator: '_')
    "#{EXTRACTION_FOLDER}/#{name_str}__-__#{page_str}.json"
  end

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
