class Extraction
  EXTRACTION_FOLDER = "#{Rails.root}/extractions"

  def initialize(extraction_definition)
    @extraction_definition = extraction_definition
    @records = []
  end

  def call
    p "Fetching from page #{@extraction_definition.page}"
    response = request_and_save
    total_results   = JsonPath.new(@extraction_definition.total_selector).on(response.body).first.to_i
    max_pages       = (total_results / @extraction_definition.per_page) + 1

    (@extraction_definition.page...max_pages).each do
      @extraction_definition.page += 1
      p "Fetching from page #{@extraction_definition.page}"

      request_and_save
      sleep @extraction_definition.throttle
      break if @extraction_definition.page > 3
    end
  end

  private

  def request_and_save
    connection = create_connection
    response = request(connection)
    save_extraction(connection, response)
    response
  end

  def create_connection
    Faraday.new(url:, params:, headers:) do |f|
      f.response :follow_redirects, limit: 5
      f.adapter Faraday.default_adapter
    end
  end

  def request(connection)
    connection.get
  end

  def save_extraction(connection, response)
    page_str = format('%05d', @extraction_definition.page)[-5..]
    name_str = @extraction_definition.name.parameterize(separator: '_')
    File.write(
      "#{EXTRACTION_FOLDER}/#{name_str}__-__#{page_str}_response.json",
      response.to_json
    )
    File.write(
      "#{EXTRACTION_FOLDER}/#{name_str}__-__#{page_str}_request.json",
      { url: connection.build_url, params: connection.params, headers: connection.headers }.to_json
    )
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
