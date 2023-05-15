# frozen_string_literal: true
module Load
  class Execution
    def initialize(record, destination)
      @record = record
      @destination = destination
    end

    def call
      record = JSON.parse(@record.to_json)['transformed_record']

      # Where we get the source_id to be confirmed
      record.merge!(source_id: 'test', data_type: 'record')
      
      conn = connection("#{@destination.url}", {}, { 'Authentication-Token' => @destination.api_key})
        .post(
          '/harvester/records',
          {
            record: record
          }.to_json,
          "Content-Type" => "application/json"
        )
    end

    private

    # TODO
    # How can we reuse our existing request object?
    def connection(url, params, headers)
      Faraday.new(url:, params:, headers:) do |f|
        f.response :follow_redirects, limit: 5
        f.adapter Faraday.default_adapter
      end
    end
  end
end