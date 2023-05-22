module Extraction
  class EnrichmentExtraction
    attr_accessor :document

    def initialize(extraction_definition, record)
      @extraction_definition = extraction_definition
      @record = record
    end

    def extract
      Sidekiq.logger.info "Fetching records from the Enrichment Source"
      @document = Extraction::Request.new(url:, params:, headers:).get
    end

    private

    def url
      block = ->(record) { eval(@extraction_definition.enrichment_url) }
      block.call(@record)
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
