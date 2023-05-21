# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_job # used for previewing, needs to be refactored
  has_many :fields

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
  
  default_scope { where(original_transformation_definition_id: nil) }

  validates :name, presence: true, uniqueness: { scope: :content_partner_id }

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
end
