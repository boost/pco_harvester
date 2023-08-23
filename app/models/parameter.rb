# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request

  enum :kind, { query: 0, header: 1, slug: 2 }
  enum :content_type, { static: 0, dynamic: 1, incremental: 2 }

  def evaluate(response = nil, page = nil)
    return self if static?
    return Parameter.new(name:, content: content.to_i * (page - 1)) if incremental?

    begin
      block = ->(_response) { eval(content) }

      Parameter.new(
        name:,
        content: block.call(response)
      )
    rescue StandardError
    end
  end

  def to_h
    return if slug?

    {
      name => content
    }
  end
end
