# frozen_string_literal: true

class Pipeline < ApplicationRecord
  validates :name, presence: true
end
