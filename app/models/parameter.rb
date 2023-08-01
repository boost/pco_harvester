# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request
  
  enum :kind, { query: 0, header: 1, slug: 2 }
end