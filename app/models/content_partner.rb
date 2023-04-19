# frozen_string_literal: true

class ContentPartner < ApplicationRecord
  has_many :extraction_definitions

  validates :name, presence: true, uniqueness: true
end
