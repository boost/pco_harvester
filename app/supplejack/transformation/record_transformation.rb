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

      delete_fields = @delete_conditions.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      transformed_fields = @fields.map do |field|
        FieldExecution.new(field).execute(@record)
      end

      TransformedRecord.new(transformed_fields, reject_fields, delete_fields)
    end
  end
end
