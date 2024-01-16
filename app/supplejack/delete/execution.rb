# frozen_string_literal: true

module Delete
  class Execution
    include HttpClient

    def initialize(record, destination)
      @record = record
      @destination = destination
    end

    def call
      connection(@destination.url, {}, { 'Authentication-Token' => @destination.api_key })
        .put(
          '/harvester/records/delete',
          {
            id: @record['transformed_record']['internal_identifier']
          }.to_json,
          'Content-Type' => 'application/json'
        )
    end
  end
end
