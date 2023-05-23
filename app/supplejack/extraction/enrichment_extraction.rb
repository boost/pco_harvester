module Extraction
  class EnrichmentExtraction
    attr_accessor :document

    def initialize(extraction_definition, record, page, extraction_folder = nil)
      @extraction_definition = extraction_definition
      @record = record
      @extraction_folder = extraction_folder
      @page = page
    end

    def extract
      Sidekiq.logger.info 'Fetching records from the Enrichment Source'
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

    # rubocop:disable Lint/UnusedBlockArgument
    def url
      block = ->(record) { eval(@extraction_definition.enrichment_url) }
      block.call(@record)
    end
    # rubocop:enable Lint/UnusedBlockArgument

    def file_path
      name_str = @extraction_definition.name.parameterize(separator: '_')
      page_str = format('%09d', @page)[-9..]
      "#{@extraction_folder}/#{@record['id']}__#{page_str}.json"
    end

    def params; end

    def headers
      {
        'Content-Type' => 'application/json',
        'User-Agent' => 'Supplejack Harvester v2.0'
      }
    end
  end
end
