# frozen_string_literal: true

# Used to store the information for running an extraction
#
class ExtractionDefinition < ApplicationRecord
  FORMATS = %w[JSON XML HTML].freeze

  # The destination is used for Enrichment Extractions
  # To know where to pull the records that are to be enriched from
  belongs_to :destination, optional: true
  belongs_to :pipeline
  belongs_to :last_edited_by, class_name: 'User', optional: true

  has_many :harvest_definitions, dependent: :nullify
  has_many :extraction_jobs, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :parameters, through: :requests

  enum :kind, { harvest: 0, enrichment: 1 }

  after_create do
    if name.blank?
      self.name = "#{pipeline.name.parameterize}__#{kind}-extraction-#{id}"
      save!
    end
  end

  # find good regex or another implementation
  FORMAT_SELECTOR_REGEX_MAP = {
    JSON: /^\$\./,
    XML: %r{^/},
    HTML: %r{^/},
    OAI: %r{^/}
  }.freeze

  validates :name, uniqueness: true

  validates :throttle, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60_000 }

  validates :page, numericality: { only_integer: true }
  validates :per_page, numericality: { only_integer: true }

  # Harvest related validation
  with_options if: :harvest? do
    validates :format, presence: true, inclusion: { in: FORMATS }
    validates :base_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
    validate :total_selector_format
    validates :total_selector, presence: true
  end

  with_options presence: true, if: :enrichment? do
    validates :destination_id
    validates :source_id
  end

  def total_selector_format
    return if FORMAT_SELECTOR_REGEX_MAP[format&.to_sym]&.match?(total_selector)

    errors.add(:total_selector, "invalid selector for the #{format} format")
  end

  def to_h
    {
      id:,
      name:
    }
  end

  def shared?
    harvest_definitions.count > 1
  end

  def clone(pipeline, name)
    cloned_extraction_definition = ExtractionDefinition.new(dup.attributes.merge(name:, pipeline:))

    requests.each do |request|
      cloned_request = request.dup
      request.parameters.each { |parameter| cloned_request.parameters << parameter.dup }

      cloned_extraction_definition.requests << cloned_request
    end

    cloned_extraction_definition
  end
end
