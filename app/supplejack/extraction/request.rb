# frozen_string_literal: true

module Extraction
  # Makes the actual request
  # Stores the request and response details
  class Request
    def initialize(url:, params: {}, headers: {})
      @connection = Connection.new(url:, params:, headers:)
    end

    # Returns a document based on the given request
    #
    # @return Document object
    def get
      @response = @connection.get
      Document.new(
        url: @connection.url,
        method: 'GET',
        params: @connection.params,
        request_headers: @connection.headers,
        status: @response.status,
        response_headers: @response.headers,
        body: @response.body
      )
    end
  end
end
