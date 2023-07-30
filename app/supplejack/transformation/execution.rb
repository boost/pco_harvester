# frozen_string_literal: true

module Transformation
  # Performs the transformation details as described in a field of a transformation definition
  class Execution
    def initialize(records, fields, reject_conditions, delete_conditions)
      @records = records
      @fields = fields
      @reject_conditions = reject_conditions
      @delete_conditions = delete_conditions
    end

    def call
      @records.map do |record|
        RecordTransformation.new(record, @fields, @reject_conditions, @delete_conditions).transform
      end
    end
  end
end
