# frozen_string_literal: true

class ContentPartner < ApplicationRecord
  has_many :extraction_definitions
  has_many :transformations

  validates :name, presence: true, uniqueness: true
end
