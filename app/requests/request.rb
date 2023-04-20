class Request
  delegate :status, :body, :headers, to: :@response
  delegate :url, :params, :headers, to: :@connection

  def initialize(url:, params: {}, headers: {})
    @connection = Connection.new(url:, params:, headers:)
  end

  def get
    @response = @connection.get
    self
  end

  def post
    @response = @connection.post
    self
  end

  def to_json(*args)
    JSON.generate({ request: @connection.to_hash, response: @response.to_hash }, *args)
  end
end
