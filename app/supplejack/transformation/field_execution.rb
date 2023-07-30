# frozen_string_literal: true

module Transformation
  # Only executes the code from the user
  class FieldExecution
    def initialize(field)
      @field = field
    end

    # rubocop:disable Lint/UnusedBlockArgument
    # rubocop:disable Security/Eval
    # rubocop:disable Lint/RescueException
    def execute(api_record)
      begin
        block = ->(record) { [eval(@field.block)].flatten(1) }

        @value = block.call(api_record)
      rescue Exception => e
        @error = e
      end

      Transformation::Field.new(@field.id, @field.name, @value, @error)
    end
    # rubocop:enable Lint/UnusedBlockArgument
    # rubocop:enable Security/Eval
    # rubocop:enable Lint/RescueException

    def condition_met?
      @value.include?(true)
    end
  end
end
