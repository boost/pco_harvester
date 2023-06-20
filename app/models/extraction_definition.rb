# frozen_string_literal: true

# Used to store the information for running an extraction
#
class ExtractionDefinition < ApplicationRecord
  scope :originals, -> { where(original_extraction_definition: nil) }

  belongs_to :content_source
  has_many :extraction_jobs
  belongs_to :destination, optional: true

  enum :kind, { harvest: 0, enrichment: 1 }

  after_create do
    self.name = "#{content_source.name.parameterize}__#{kind}-extraction-#{id}"
    save!
  end

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
    XML: %r{^/},
    OAI: %r{^/}
  }.freeze

  validates :throttle, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60_000 }
  validate :cannot_be_a_copy_of_self

  # Harvest related validation
  with_options if: :harvest? do
    validates :format, presence: true, inclusion: { in: %w[JSON XML OAI] }
    validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }

    with_options if: ->{ pagination_type == 'page' } do
      validate :total_selector_format
      validates :total_selector, presence: true
    end
    
    with_options presence: true, if: ->{ pagination_type == 'tokenised' } do
      validates :next_page_token_location
      # TODO rename this field when I understand what it's actually for
      validates :initial_param
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

  def copy?
    original_extraction_definition.present?
  end

  def cannot_be_a_copy_of_self
    if original_extraction_definition == self
      errors.add(:copy, 'Extraction Definition cannot be a copy of itself')
    end
  end
end
