# frozen_string_literal: true

module DeletePreviousRecords
  class Execution
    def initialize(source_id, job_id, destination)
      @source_id = source_id
      @job_id = job_id
      @destination = destination
    end

    def call
      connection(@destination.url, {}, { 'Authentication-Token' => @destination.api_key })
        .post(
          '/harvester/records/flush',
          {
            source_id: @source_id,
            job_id: @job_id
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
