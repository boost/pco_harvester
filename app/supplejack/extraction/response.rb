module Extraction
  class Response
    attr_reader :status, :headers, :body

    def initialize(response)
      @status = response.status
      @headers = response.headers
      @body = response.body
    end
  end
end
