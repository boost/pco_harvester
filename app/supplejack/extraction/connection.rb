# frozen_string_literal: true

# Wrapper interface for the HTTP Client used in Supplejack
# Intended on making transitioning to different HTTP Clients easier in the future
# As the client itself is abstracted away from our HTTP calls
#
module Extraction
  class Connection
    attr_reader :url, :params, :headers

    def initialize(url:, params: {}, headers: {})
      headers ||= {}

      @connection = connection(url, params, headers)
      @url        = @connection.build_url
      @params     = @connection.params
      @headers    = @connection.headers
    end

    def get
      Response.new(@connection.get)
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
