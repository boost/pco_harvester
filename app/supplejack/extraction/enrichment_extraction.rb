# frozen_string_literal: true

module Extraction
  class EnrichmentExtraction < AbstractExtraction
    def initialize(request, record, page = 1, extraction_folder = nil)
      super()
      @request = request
      @extraction_definition = request.extraction_definition
      @record = record
      @page = page
      @extraction_folder = extraction_folder
    end

    private

    def url
      @request.url(@record)
    end

    def params
      @request.query_parameters(@record)
    end

    def headers
      return super if @request.headers.blank?

      super.merge(@request.headers(@response))
    end

    def file_path
      name_str = @extraction_definition.name.parameterize(separator: '_')
      page_str = format('%09d', @page)[-9..]
      "#{@extraction_folder}/#{name_str}__#{@record['id']}__#{page_str}.json"
    end
  end
end
