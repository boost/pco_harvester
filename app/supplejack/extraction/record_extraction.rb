module Extraction
  class RecordExtraction < AbstractExtraction
    def initialize(extraction_definition, page, harvest_job = nil)
      @extraction_definition = extraction_definition
      @api_source            = extraction_definition.destination
      @page = page
      @harvest_job = harvest_job
    end

    private

    def url
      "#{@api_source.url}/harvester/records"
    end

    def params
      {
        search: {}.merge(
          if @harvest_job&.target_job_id.present?
            {
              'fragments.job_id' => @harvest_job.target_job_id
            }
          else
            {
              'fragments.source_id' => @extraction_definition.source_id
            }
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
