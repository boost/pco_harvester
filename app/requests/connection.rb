class Connection
  delegate :url, :params, :headers, to: :@connection

  def initialize(url:, params: {}, headers: {})
    @connection = Faraday.new(url:, params:, headers:) do |f|
      f.response :follow_redirects, limit: 5
      f.adapter Faraday.default_adapter
    end
  end

  def get
    @method = 'GET'
    Response.new(@connection.get)
  end

  def post
    @method = 'POST'
    Response.new(@connection.post)
  end

  def url
    @connection.build_url
  end

  def to_hash
    { url:, method: @method, params:, headers: }
  end
end
