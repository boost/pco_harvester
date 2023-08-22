# frozen_string_literal: true

module Transformation
  # Only stores the result of the transformation or the error associated with it
  class TransformedField
    attr_reader :id, :name, :value, :error

    def initialize(id, name, value, exception)
      @id = id
      @name = name
      @value = cast(value)
      @error = exception.present? ? Error.new(exception) : nil
    end

    def cast(value)
      return value.to_time.to_s if value.class.in?([Date, DateTime, Time])

      value
    end
  end
end
