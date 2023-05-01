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
      raise 'This code should not be executed in tests' if Rails.env.test?

      Faraday.new(url:, params:, headers:) do |f|
        f.response :follow_redirects, limit: 5
        f.adapter Faraday.default_adapter
      end
    end
  end
end
