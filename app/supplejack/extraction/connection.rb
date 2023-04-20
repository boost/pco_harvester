module Extraction
  class Connection
    attr_reader :url, :method, :params, :headers

    def initialize(url:, params: {}, headers: {})
      @connection = Faraday.new(url:, params:, headers:) do |f|
        f.response :follow_redirects, limit: 5
        f.adapter Faraday.default_adapter
      end

      @url = @connection.build_url
      @method = nil
      @params = @connection.params
      @headers = @connection.headers
    end

    def get
      @method = 'GET'
      Response.new(@connection.get)
    end
  end
end
