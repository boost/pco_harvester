# frozen_string_literal: true

# Used to store the inforamation for running an extraction
#
class ExtractionDefinition < ApplicationRecord
  scope :harvests,    -> { where(kind: 0) }
  scope :enrichments, -> { where(kind: 1) }

  belongs_to :content_partner
  has_many :extraction_jobs
  
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

  default_scope { where(original_extraction_definition_id: nil) }

  # find good regex or another implementation
  FORMAT_SELECTOR_REGEX_MAP = {
    JSON: /^\$\./,
    HTML: %r{^/},
    XML: %r{^/},
    OAI: %r{^/}
  }.freeze

  validates :name, presence: true, uniqueness: { scope: :content_partner_id }
  validates :format, presence: true, inclusion: { in: %w[JSON HTML XML OAI] }
  validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :throttle, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60_000 }
  validate :total_selector_format

  # pagination fields
  validates :pagination_type, presence: true, inclusion: { in: %w[item page] }
  validates :page, numericality: { only_integer: true }
  validates :per_page, numericality: { only_integer: true }

  validates :total_selector, presence: true

  def total_selector_format
    return if FORMAT_SELECTOR_REGEX_MAP[format&.to_sym]&.match?(total_selector)

    errors.add(:total_selector, "invalid selector for the #{format} format")
  end
end
