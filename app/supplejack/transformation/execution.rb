# frozen_string_literal: true

module Transformation
  # Performs the transformation details as described in a field of a transformation definition
  class Execution
    def initialize(extracted_records, fields, api_record = nil)
      @extracted_records = extracted_records
      @api_record = api_record
      @fields = fields
    end

    def call
      @extracted_records.map do |extracted_record|
        RecordTransformation.new(extracted_record, @fields, @api_record).transform
      end
    end
  end
end
