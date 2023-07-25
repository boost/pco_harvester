# frozen_string_literal: true

module Transformation
  # This class performs the transformation of a single record
  # It provides details about the execution of the transformation
  # such as errors and transformation results
  class RecordTransformation
    def initialize(record, fields, reject_conditions, delete_conditions)
      @record = record
      @fields = fields
      @reject_conditions = reject_conditions
      @delete_conditions = delete_conditions
    end

    def transform
      reject_fields = @reject_conditions.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      return TransformedRecord.new([], reject_fields) if reject_fields.any?(&:condition_met?)

      delete_fields = @delete_conditions.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      return TransformedRecord.new([], [], delete_fields) if delete_fields.any?(&:condition_met?)

      transformed_fields = @fields.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      TransformedRecord.new(transformed_fields)
    end
  end
end
