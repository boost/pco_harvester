# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_job # used for previewing, needs to be refactored
  has_many :fields

  scope :harvests,    -> { where(kind: :harvest) }
  scope :enrichments, -> { where(kind: :enrichment) }
  scope :originals, -> { where(original_transformation_definition: nil) }

  KINDS = %w[harvest enrichment].freeze
  enum :kind, KINDS

  validates :record_selector, presence: true
  validate :cannot_be_a_copy_of_self

  after_create do
    self.name = "#{content_partner.name.parameterize}__#{kind}-transformation-#{id}"
    save!
  end

  # feature allows editing a transformation definition without impacting a running harvest
  belongs_to(
    :original_transformation_definition,
    class_name: 'TransformationDefinition',
    optional: true
  )

  has_many(
    :copies,
    class_name: 'TransformationDefinition',
    foreign_key: 'original_transformation_definition_id',
    inverse_of: 'original_transformation_definition'
  )

  # Returns the records from the job based on the given record_selector
  # Used for previewing, needs to be refactored
  #
  # @return Array
  def records(page = 1)
    return [] if record_selector.blank? || extraction_job.documents[page].nil?

    JsonPath.new(record_selector)
            .on(extraction_job.documents[page].body)
            .flatten
  end

  def copy?
    original_transformation_definition.present?
  end

  def cannot_be_a_copy_of_self
    if original_transformation_definition == self
      errors.add(:copy, 'Transformation Definition cannot be a copy of itself')
    end
  end
end
