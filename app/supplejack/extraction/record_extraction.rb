module Extraction
  class RecordExtraction
    attr_accessor :document 

    def initialize(extraction_definition, page)
      @extraction_definition = extraction_definition
      @api_source            = extraction_definition.destination
      @page = page
    end
    
    def extract
      Sidekiq.logger.info "Fetching records from the API"
      @document = Extraction::Request.new(url:, params:, headers:).get
    end

    private

    def url
      "#{@api_source.url}/harvester/records"
    end

    def params
      {
        search: {
          "fragments.source_id" => @extraction_definition.source_id,
        },
        search_options: {
          page: @page
        },
        api_key: @api_source.api_key
      }
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'User-Agent' => 'Supplejack Harvester v2.0'
      }
    end
  end
end
