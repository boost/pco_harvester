# frozen_string_literal: true

module Extraction
  class DocumentExtraction < AbstractExtraction
    def initialize(request, extraction_folder = nil)
      @request = request
      @extraction_folder = extraction_folder
      @extraction_definition = request.extraction_definition
    end

    private

    def file_path
      page_str = format('%09d', @extraction_definition.page)[-9..]
      name_str = @extraction_definition.name.parameterize(separator: '_')
      "#{@extraction_folder}/#{name_str}__-__#{page_str}.json"
    end

    def url
      @request.url
    end

    def params
      @request.query_parameters
    end

    def headers
      return super if @request.headers.blank?

      super.merge(@request.headers)
    end

    # There are scenarios where a harvester adds a string of additional params
    # that are only used on the very first API call to the Content Source.
    # These params can actually break subsequent calls if they are added where they are not expected to be.
    # These params can also include blocks of Ruby code. For instance they may have a dynamic date.
    #
    # @return Hash of params.
    # def initial_params
    #   return {} if @extraction_definition.initial_params.blank?

    #   CGI.parse(eval(@extraction_definition.initial_params)).transform_values(&:first)
    # end
  end
end
