# frozen_string_literal: true

module Extraction
  class DocumentExtraction < AbstractExtraction
    def initialize(extraction_definition, extraction_folder = nil)
      @extraction_definition = extraction_definition
      @extraction_folder = extraction_folder
    end

    private

    def file_path
      page_str = format('%09d', @extraction_definition.page)[-9..]
      name_str = @extraction_definition.name.parameterize(separator: '_')
      "#{@extraction_folder}/#{name_str}__-__#{page_str}.json"
    end

    def url
      @extraction_definition.base_url
    end

    def params
      {
        @extraction_definition.page_parameter => @extraction_definition.page,
        @extraction_definition.per_page_parameter => @extraction_definition.per_page,
        @extraction_definition.token_parameter => @extraction_definition.token_value,
      }
        .reject { |key, value| key.blank? || value.blank? }
        .merge(
          if @extraction_definition.page == 1          
            initial_params
          else
            {}
          end
        )
    end

    def initial_params
      return {} if @extraction_definition.initial_params.blank?

      CGI.parse(eval(@extraction_definition.initial_params)).transform_values(&:first)
    end
  end
end
