# frozen_string_literal: true

require 'webmock'

module Transformation
  # Only executes the code from the user
  class FieldExecution
    include WebMock::API

    def initialize(field)
      @field = field
    end

    # rubocop:disable Lint/UnusedBlockArgument
    # rubocop:disable Security/Eval
    # rubocop:disable Lint/RescueException
    def execute(api_record)
      WebMock.enable!
      begin
        block = ->(record) { eval(@field.block) }

        @value = block.call(api_record)
      rescue Exception => e
        @error = e
      end

      WebMock.disable!
      Transformation::Field.new(@field.id, @field.name, @value, @error)
    end
    # rubocop:enable Lint/UnusedBlockArgument
    # rubocop:enable Security/Eval
    # rubocop:enable Lint/RescueException
  end
end
