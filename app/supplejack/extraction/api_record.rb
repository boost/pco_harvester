# frozen_string_literal: true

module Extraction
  class ApiRecord
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def [](index)
      @body[index]
    end

    def to_hash
      {
        body: body.to_json
      }
    end
  end
end