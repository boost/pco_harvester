module Extraction
  class Response
    attr_reader :status, :body, :headers

    def initialize(response)
      @status = response.status
      @headers = response.headers
      @body = response.body
    end
  end
end
