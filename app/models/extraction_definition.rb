# frozen_string_literal: true

# Used to store the information for running an extraction
#
class ExtractionDefinition < ApplicationRecord
  scope :originals, -> { where(original_extraction_definition: nil) }

  # The destination is used for Enrichment Extractions
  # To know where to pull the records that are to be enriched from
  belongs_to :destination, optional: true
  belongs_to :pipeline

  has_many :extraction_jobs
  has_many :headers

  enum :kind, { harvest: 0, enrichment: 1 }

  accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: proc { |attribute| attribute[:name].blank? && attribute[:value].blank? }

  after_create do
    self.name = "#{pipeline.name.parameterize}__#{kind}-extraction-#{id}"
    save!
  end

  # find good regex or another implementation
  FORMAT_SELECTOR_REGEX_MAP = {
    JSON: /^\$\./,
    XML: %r{^/},
    HTML: %r{^/},
    OAI: %r{^/}
  }.freeze

  validates :throttle, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60_000 }

  # Harvest related validation
  with_options if: :harvest? do
    validates :format, presence: true, inclusion: { in: %w[JSON XML HTML] }
    validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
    validate :total_selector_format
    validates :total_selector, presence: true

    with_options presence: true, if: -> { pagination_type == 'tokenised' } do
      validates :next_token_path
      validates :token_parameter
      validates :token_value
    end
  end

  # pagination fields
  validates :pagination_type, presence: true, inclusion: { in: %w[page tokenised] }, if: -> { harvest? }
  validates :page, numericality: { only_integer: true }
  validates :per_page, numericality: { only_integer: true }

  with_options presence: true, if: :enrichment? do
    validates :destination_id
    validates :source_id
    validates :enrichment_url
  end

  def total_selector_format
    return if FORMAT_SELECTOR_REGEX_MAP[format&.to_sym]&.match?(total_selector)

    errors.add(:total_selector, "invalid selector for the #{format} format")
  end

  def to_h
    { 
      id: id,
      name: name
    }
  end
end
