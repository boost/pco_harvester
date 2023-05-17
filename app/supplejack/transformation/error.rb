# frozen_string_literal: true

module Transformation
  # Only stores the result of the transformation or the error associated with it
  class Error
    attr_reader :title, :description

    def initialize(exception)
      return if exception.nil?

      @title = exception.class
      @description = exception.message
    end

    def to_hash
      return nil if @title.nil?

      {
        title:,
        description:
      }
    end
  end
end
