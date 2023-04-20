class ExtractionJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(extraction_definition_id)
    @extraction_definition = ExtractionDefinition.find(extraction_definition_id)

    faraday_params = {
      url: @extraction_definition.base_url,
      params: {
        @extraction_definition.page_parameter => @extraction_definition.page,
        @extraction_definition.per_page_parameter => @extraction_definition.per_page
      },
      headers: {
        'Content-Type' => 'application/json',
        'User-Agent' => 'Supplejack Harvester v2.0'
      }
    }
    
    records = []

    initial_request = Faraday.new(faraday_params).get
    total_results   = JSON.parse(initial_request.body)['search']['result_count']
    max_pages       = (total_results / @extraction_definition.per_page) + 1

    (@extraction_definition.page...max_pages).each do
      p "Fetching from page #{@extraction_definition.page}"

      response = Faraday.new(faraday_params) do |f|
        f.use FaradayMiddleware::FollowRedirects, limit: 5
        f.adapter Faraday.default_adapter
      end.get

      records.push(JSON.parse(response.body)['search']['results'])

      sleep @extraction_definition.throttle

      @extraction_definition.page += 1
    end
    
    File.write("#{Rails.root}/app/extractions/#{@extraction_definition.name.parameterize(separator: '_')}.json", records.flatten.to_json)
   end
end
