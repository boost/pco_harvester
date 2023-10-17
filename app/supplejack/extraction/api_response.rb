# frozen_string_literal: true

module Extraction
  class ApiResponse
    def initialize(response)
      @response = response
    end

    def record(index)
      ApiRecord.new(JSON.parse(@response.body)['records'][index])
    end
  end
end
