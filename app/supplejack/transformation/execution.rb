# frozen_string_literal: true

module Transformation
  # Performs the transformation details as described in a field of a transformation definition
  class Execution
    def initialize(records, fields)
      @records = records
      @fields = fields
    end

    def call
      @records.map do |record|
        RecordTransformation.new(record, @fields).transform
      end
    end
  end
end
