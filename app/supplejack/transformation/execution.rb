# frozen_string_literal: true

module Transformation
  # Performs the transformation details as described in a field of a transformation definition
  class Execution
    def initialize(record, field)
      @record = record
      @field = field
    end

    def call
      block = ->(record) { eval(@field.block) }

      block.call(@record)
    end
  end
end
