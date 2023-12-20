# frozen_string_literal: true

class StopCondition < ApplicationRecord
  belongs_to :extraction_definition

  # rubocop:disable Lint/UnusedBlockArgument
  # rubocop:disable Security/Eval
  def evaluate(document)
    block = ->(response) { eval(content) }

    block.call(document)
  rescue StandardError => e
    e
  end
  # rubocop:enable Lint/UnusedBlockArgument
  # rubocop:enable Security/Eval
end
