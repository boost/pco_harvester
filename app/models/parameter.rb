# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request
  
  enum :kind, { query: 0, header: 1, slug: 2 }

  def to_h
    return if slug?
    
    {
      name => content
    }
  end

  def evaluate(request = nil)
    return self unless dynamic?

    block = ->(request) { eval(content) }

    Parameter.new(
      name: name,
      content: block.call(request)
    )
  end
end