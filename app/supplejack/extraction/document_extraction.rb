# frozen_string_literal: true

module Extraction
  class DocumentExtraction < AbstractExtraction
    def initialize(request, extraction_folder = nil, response = nil)
      @request = request
      @extraction_folder = extraction_folder
      @extraction_definition = request.extraction_definition
      @response = response
    end

    private

    def file_path
      page_str = format('%09d', @extraction_definition.page)[-9..]
      name_str = @extraction_definition.name.parameterize(separator: '_')
      "#{@extraction_folder}/#{name_str}__-__#{page_str}.json"
    end

    def url
      @request.url(@response)
    end

    def params
      @request.query_parameters(@response)
    end

    def headers
      return super if @request.headers(@extraction_definition.page).blank?

      super.merge(@request.headers(@response))
    end
  end
end
