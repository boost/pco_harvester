# frozen_string_literal: true

module Extraction
  class DocumentExtraction < AbstractExtraction
    def initialize(request, extraction_folder = nil, previous_request = nil)
      @request = request
      @extraction_folder = extraction_folder
      @extraction_definition = request.extraction_definition
      @previous_request = previous_request
    end

    private

    def file_path
      page_str = format('%09d', @extraction_definition.page)[-9..]
      name_str = @extraction_definition.name.parameterize(separator: '_')
      "#{@extraction_folder}/#{name_str}__-__#{page_str}.json"
    end

    def url
      @request.url(@previous_request)
    end

    def params
      @request.query_parameters(@previous_request)
    end

    def headers
      return super if @request.headers.blank?

      super.merge(@request.headers(@previous_request))
    end
  end
end
