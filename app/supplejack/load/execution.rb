# frozen_string_literal: true

module Load
  class Execution
    def initialize(record, harvest_job, api_record_id = nil)
      @record             = record
      @harvest_job        = harvest_job
      @destination        = harvest_job.pipeline_job.destination
      @harvest_definition = harvest_job.harvest_definition
      @api_record_id      = api_record_id
    end

    def call
      if @harvest_definition.harvest?
        harvest_request
      elsif @harvest_definition.enrichment?
        enrichment_request
      end
    end

    private

    def harvest_request
      connection(@destination.url, {}, { 'Authentication-Token' => @destination.api_key })
        .post(
          '/harvester/records',
          { record: build_record }.to_json,
          headers
        )
    end

    def enrichment_request
      required_fragments = [@harvest_definition.source_id] if @harvest_definition.required_for_active_record?

      connection(@destination.url, {}, { 'Authentication-Token' => @destination.api_key })
        .post(
          "/harvester/records/#{@api_record_id}/fragments.json",
          { fragment: build_record, required_fragments: }.to_json,
          headers
        )
    end

    def build_record
      record = JSON.parse(@record.to_json)['transformed_record']
      record.transform_values! { |value| [value].flatten(1) }

      record['source_id'] = @harvest_definition.source_id
      record['priority']  = @harvest_definition.priority
      record['job_id']    = @harvest_job.name
      record
    end

    def headers
      { 'Content-Type' => 'application/json' }
    end

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
