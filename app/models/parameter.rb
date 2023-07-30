# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request

  validates :key,   presence: true
  validates :value, presence: true
  
  enum :kind, { query: 0, header: 1, slug: 2 }
end