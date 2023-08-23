# frozen_string_literal: true

module Transformation
  class TypeChecker
    def initialize(value)
      @value = value
      @faulty_variable = nil
    end

    def valid?
      return true if allowed_raw_type?(@value)
      return false unless allowed_iterable_type?(@value)
      return true if @value.empty?

      @value.none? do |key, value|
        !allowed_raw_type?(key) || !allowed_raw_type?(value)
      end
    end

    def error
      return nil if @faulty_variable.nil?

      "Field contains a wrong type: #{@faulty_variable.class}. The field returned: #{@value.inspect}"
    end

    def allowed_raw_type?(value)
      return true if value.class.in?(allowed_raw_types)

      @faulty_variable = value
      false
    end

    def allowed_iterable_type?(value)
      return true if value.class.in?(allowed_iterable_types)

      @faulty_variable = value
      false
    end

    def allowed_iterable_types
      [Array, Hash]
    end

    def allowed_raw_types
      [NilClass, TrueClass, FalseClass, Integer, Float, String, Symbol]
    end
  end
end
