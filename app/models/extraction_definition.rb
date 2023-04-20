# frozen_string_literal: true

class ExtractionDefinition < ApplicationRecord
  belongs_to :content_partner
  # find good regex or another implementation
  FORMAT_SELECTOR_REGEX_MAP = {
    JSON: /^\$\./,
    HTML: /^\//,
    XML: /^\//,
    OAI: /^\//
  }

  validates :name, presence: true, uniqueness: { scope: :content_partner }
  validates :format, presence: true, inclusion: { in: %w[JSON HTML XML OAI] }
  validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :throttle, numericality: { only_integer: true }
  validate :total_selector_format

  # pagination fields
  validates :pagination_type, presence: true, inclusion: { in: %w[item page] }
  validates :page, numericality: { only_integer: true }
  validates :per_page, numericality: { only_integer: true }

  validates :total_selector, presence: true

  def total_selector_format
    return if FORMAT_SELECTOR_REGEX_MAP[format.to_sym].match?(total_selector)

    errors.add(:total_selector, "invalid selector for the #{format} format")
  end
end
