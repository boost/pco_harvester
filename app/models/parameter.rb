# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request

  enum :kind, { query: 0, header: 1, slug: 2 }

  def evaluate(response = nil)
    return self unless dynamic?

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
