module Extraction
  class Connection
    def initialize(url:, params: {}, headers: {})
      @connection = connection(url, params, headers)
      @method     = nil
      @params     = @connection.params
      @headers    = @connection.headers
    end

    def get
      @method = 'GET'
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
