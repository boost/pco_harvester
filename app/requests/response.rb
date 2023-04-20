class Response
  delegate :status, :body, :headers, to: :@response

  def initialize(response)
    @response = response
  end

  def url
    @response.env.url
  end

  def to_hash
    { status:, url:, headers:, body: }
  end
end
