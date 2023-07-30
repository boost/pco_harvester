 # frozen_string_literal: true

module Delete
  class Execution
    def initialize(record, delete_job)
      @record = record
      @delete_job = delete_job
      @destination = delete_job.harvest_job.destination
    end

    def call
      connection(@destination.url, {}, { 'Authentication-Token' => @destination.api_key })
        .put(
          '/harvester/records/delete',
          {
            id: @record['transformed_record']['internal_identifier'].first
          }.to_json,
          'Content-Type' => 'application/json'
        )
    end
  
    private

    def connection(url, params, headers)
      Faraday.new(url:, params:, headers:) do |f|
        f.response :follow_redirects, limit: 5
        f.adapter Faraday.default_adapter
      end
    end
  end
end
