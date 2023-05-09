# frozen_string_literal: true

module Transformation
  # Performs the transformation details as described in a field of a transformation definition
  class Execution
    def initialize(records, fields)
      @records = records
      @fields = fields
    end

    def call
      OpenStruct.new(
        transformed_records: transform_records,
        errored_records: []
      )
    end

    def transform_records
      @records.map do |record|
        @fields.each_with_object({}) do |field, transformed_record|
          block = ->(record) { eval(field.block) }

          begin
            transformed_record[field.name] = block.call(record)
          rescue => error
          end
        end
      end
    end
  end
end
