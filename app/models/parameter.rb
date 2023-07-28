# frozen_string_literal: true

class Parameter < ApplicationRecord
  belongs_to :request

  validates :key, presence: true
  validates :value, presence: true
end