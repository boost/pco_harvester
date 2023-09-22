# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :extraction_job # used for previewing, needs to be refactored
  belongs_to :pipeline
  belongs_to :last_edited_by, class_name: 'User', optional: true

  has_many :harvest_definitions, dependent: :restrict_with_exception
  has_many :fields, dependent: :destroy
  enum :kind, { harvest: 0, enrichment: 1 }

  validates :record_selector, presence: true

  after_create do
    self.name = "#{pipeline.name.parameterize}__#{kind}-transformation-#{id}"
    save!
  end

  # Returns the records from the job based on the given record_selector
  # Used for previewing, needs to be refactored
  #
  # @return Array
  def records(page = 1)
    Transformation::RawRecordsExtractor.new(self, extraction_job).records(page)
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

  def clone(pipeline, harvest_definition, name)
    cloned_transformation_definition = dup

    fields.each do |field|
      cloned_field = field.dup

      cloned_transformation_definition.fields << cloned_field
    end

    cloned_transformation_definition.save
    cloned_transformation_definition.update(pipeline:, name:)
    harvest_definition.update(transformation_definition: cloned_transformation_definition)

    cloned_transformation_definition
  end
end
