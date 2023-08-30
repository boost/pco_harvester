# frozen_string_literal: true

module Extraction
  class EnrichmentExtraction < AbstractExtraction
    def initialize(extraction_definition, record, page, extraction_folder = nil)
      @extraction_definition = extraction_definition
      @record = record
      @page = page
      @extraction_folder = extraction_folder
    end

    def valid?
      block(expression).call(@record).present?
    end

    private

    def params; end

    def expression
      @extraction_definition.enrichment_url.match(/.+(\#{(?<expression>.+)})/)[:expression]
    end

    # rubocop:disable Lint/UnusedBlockArgument
    # rubocop:disable Security/Eval
    def block(code)
      ->(record) { eval(code) }
    end
    # rubocop:enable Security/Eval
    # rubocop:enable Lint/UnusedBlockArgument

    def url
      block(@extraction_definition.enrichment_url).call(@record)
    end

    def file_path
      name_str = @extraction_definition.name.parameterize(separator: '_')
      page_str = format('%09d', @page)[-9..]
      "#{@extraction_folder}/#{name_str}__#{@record['id']}__#{page_str}.json"
    end
  end
end
