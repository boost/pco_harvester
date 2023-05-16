# frozen_string_literal: true

class Destination < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :api_key, presence: true
end
