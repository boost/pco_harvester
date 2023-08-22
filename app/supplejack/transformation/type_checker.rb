# frozen_string_literal: true

module Transformation
  class TypeChecker
    def initialize(value)
      @value = value
    end

    def valid?
      return true if @value.class.in?(allowed_raw_types)
      return false unless @value.class.in?(allowed_iterable_types)
      return true if @value.empty?

      @value.none? do |key, value|
        !key.class.in?(allowed_raw_types) ||
          !value.class.in?(allowed_raw_types)
      end
    end

    def allowed_iterable_types
      [Array, Hash]
    end

    def allowed_raw_types
      [NilClass, Boolean, Integer, Float, String, Symbol]
    end
  end
end
