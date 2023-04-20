class DocumentExtraction
  EXTRACTION_FOLDER = "#{Rails.root}/extractions/".freeze

  attr_reader :response, :connection

  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
  end

  def extract
    p "Fetching from page #{@extraction_definition.page}"
    @connection = Faraday.new(url:, params:, headers:) do |f|
      f.response :follow_redirects, limit: 5
      f.adapter Faraday.default_adapter
    end

    @response = @connection.get
  end

  def save
    File.write(response_path, response.to_json)
    File.write(request_path, {
      url: @connection.build_url,
      params: @connection.params,
      headers: @connection.headers
    }.to_json)
  end

  def extract_and_save
    extract
    save
  end

  private

  def base_path
    page_str = format('%05d', @extraction_definition.page)[-5..]
    name_str = @extraction_definition.name.parameterize(separator: '_')
    "#{EXTRACTION_FOLDER}/#{name_str}__-__#{page_str}"
  end

  def response_path
    "#{base_path}_response.json"
  end

  def request_path
    "#{base_path}_request.json"
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
