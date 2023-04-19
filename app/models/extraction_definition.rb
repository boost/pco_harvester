# frozen_string_literal: true

class ExtractionDefinition < ApplicationRecord
  belongs_to :content_partner

  validates :name, presence: true, uniqueness: true
end
