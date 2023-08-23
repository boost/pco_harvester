# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request

  enum :kind, { query: 0, header: 1, slug: 2 }
  enum :content_type, { static: 0, dynamic: 1, increment_by: 2 }

  # rubocop:disable Lint/UnusedBlockArgument
  # rubocop:disable Security/Eval
  def evaluate(response = nil)
    return self if static?
    return Parameter.new(name:, content: response.params[name].to_i + content.to_i) if increment_by?

    begin
      block = ->(response) { eval(content) }

      Parameter.new(
        name:,
        content: block.call(response&.body)
      )
    rescue StandardError
    end
  end
  # rubocop:enable Lint/UnusedBlockArgument
  # rubocop:enable Security/Eval

  def to_h
    return if slug?

    {
      name => content
    }
  end
end
