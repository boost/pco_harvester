module Extraction
  class RecordExtraction < AbstractExtraction
    def initialize(extraction_definition, page)
      @extraction_definition = extraction_definition
      @api_source            = extraction_definition.destination
      @page = page
    end

    private

    def url
      "#{@api_source.url}/harvester/records"
    end

    def params
      {
        search: {
          'fragments.source_id' => @extraction_definition.source_id,
        }.merge(
          if @extraction_definition.job_id.present?
            {
              'fragments.job_id' => @extraction_definition.job_id
            }
          else
            {}
          end
        ),
        search_options: {
          page: @page
        },
        api_key: @api_source.api_key
      }
    end
  end
end
