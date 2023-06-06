# frozen_string_literal: true

class ContentSource < ApplicationRecord
  has_many :extraction_definitions
  has_many :transformation_definitions
  has_many :harvest_definitions

  validates :name, presence: true, uniqueness: true
end
