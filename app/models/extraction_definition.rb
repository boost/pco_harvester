# frozen_string_literal: true

# Used to store the inforamation for running an extraction
#
class ExtractionDefinition < ApplicationRecord
  scope :harvests,    -> { where(kind: 0) }
  scope :enrichments, -> { where(kind: 1) }
  scope :originals,   -> { where(original_extraction_definition: nil) }

  belongs_to :content_partner
  has_many :extraction_jobs
  belongs_to :destination, optional: true

  KINDS = %w[harvest enrichment].freeze
  enum :kind, KINDS

  # feature allows editing an extraction definition  without impacting a running harvest
  belongs_to(
    :original_extraction_definition,
    class_name: 'ExtractionDefinition',
    optional: true
  )
  has_many(
    :copies,
    class_name: 'ExtractionDefinition',
    foreign_key: 'original_extraction_definition_id',
    inverse_of: 'original_extraction_definition'
  )

  # find good regex or another implementation
  FORMAT_SELECTOR_REGEX_MAP = {
    JSON: /^\$\./,
    HTML: %r{^/},
    XML: %r{^/},
    OAI: %r{^/}
  }.freeze

  validates :name, presence: true, uniqueness: { scope: :content_partner_id }
  validates :throttle, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60_000 }

  # Harvest related validation
  validates :format, presence: true, inclusion: { in: %w[JSON HTML XML OAI] },            if: -> { harvest? }
  validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }, if: -> { harvest? }
  validate :total_selector_format,                                                        if: -> { harvest? }

  # pagination fields
  validates :pagination_type, presence: true, inclusion: { in: %w[item page] },           if: -> { harvest? }

  validates :page, numericality: { only_integer: true }
  validates :per_page, numericality: { only_integer: true }
  validates :total_selector, presence: true

  # Enrichment related validation

  validates :destination_id, presence: true,                                              if: -> { enrichment? }
  validates :source_id, presence: true,                                                   if: -> { enrichment? }
  validates :enrichment_url, presence: true,                                              if: -> { enrichment? }

  def total_selector_format
    return if FORMAT_SELECTOR_REGEX_MAP[format&.to_sym]&.match?(total_selector)

    errors.add(:total_selector, "invalid selector for the #{format} format")
  end
end
