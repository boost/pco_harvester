# frozen_string_literal: true

module Transformation
  # This class performs the transformation of a single record
  # It provides details about the execution of the transformation
  # such as errors and transformation results
  class RecordTransformation
    def initialize(record, fields, conditions)
      @record = record
      @fields = fields
      @conditions = conditions
    end

    def transform
      transformed_conditions = @conditions.map do |condition|
        FieldExecution.new(condition).execute(@record)
      end

      return TransformedRecord.new([], transformed_conditions) if transformed_conditions.any?(&:condition_met?)

      transformed_fields = @fields.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      TransformedRecord.new(transformed_fields)
    end
  end
end
