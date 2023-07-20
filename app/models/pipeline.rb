# frozen_string_literal: true

class Pipeline < ApplicationRecord
  has_many :harvest_definitions

  validates :name, presence: true

  def harvest
    harvest_definitions.find(&:harvest?)
  end

  def enrichments
    harvest_definitions.select(&:enrichment?)
  end

  def ready_to_run?
    return false if harvest.blank?
    return false if harvest.extraction_definition.blank?
    return false if harvest.transformation_definition.blank?
    return false if harvest.transformation_definition.fields.empty?

    true
  end
end
