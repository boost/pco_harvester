class DocumentExtraction
  attr_reader :document

  def initialize(extraction_definition, extraction_folder = nil)
    @extraction_definition = extraction_definition
    @extraction_folder = extraction_folder
  end

  def extract
    Sidekiq.logger.info "Fetching from page #{@extraction_definition.page}" unless Rails.env.test?
    @document = Extraction::Request.new(url:, params:, headers:).get
  end

  def save
    raise ArgumentError, 'extraction_folder was not provided in #new' unless @extraction_folder.present?
    raise '#extract must be called before #save DocumentExtraction' unless @document.present?

    @document.save(file_path)
  end

  def extract_and_save
    extract
    save
  end

  private

  def file_path
    page_str = format('%05d', @extraction_definition.page)[-5..]
    name_str = @extraction_definition.name.parameterize(separator: '_')
    "#{@extraction_folder}/#{name_str}__-__#{page_str}.json"
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
