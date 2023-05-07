# frozen_string_literal: true

class ContentPartner < ApplicationRecord
  has_many :extraction_definitions
  has_many :transformation_definitions

  validates :name, presence: true, uniqueness: true
end
