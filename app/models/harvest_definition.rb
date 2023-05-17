# frozen_string_literal: true

class HarvestDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_definition, optional: true, dependent: :destroy
  belongs_to :extraction_job, optional: true
  belongs_to :transformation_definition, dependent: :destroy
  belongs_to :destination

  has_many :harvest_jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :content_partner_id }

  before_create :clone_transformation_definition
  before_create :clone_extraction_definition

  def clone_transformation_definition
    safe_transformation = transformation_definition.dup
    transformation_definition.fields.each do |field|
      safe_transformation.fields.push(field.dup)
    end
    safe_transformation.original_transformation_definition = transformation_definition
    safe_transformation.save
    self.transformation_definition = safe_transformation
  end

  def update_transformation_definition_clone(transformation_definition)
    self.transformation_definition.destroy
    self.transformation_definition = transformation_definition
    clone_transformation_definition
    save
  end

  def clone_extraction_definition
    safe_extraction = extraction_definition.dup
    safe_extraction.original_extraction_definition = extraction_definition
    safe_extraction.save
    self.extraction_definition = safe_extraction
  end

  def update_extraction_definition_clone(extraction_definition)
    self.extraction_definition.destroy
    self.extraction_definition = extraction_definition
    clone_extraction_definition
    save
  end
end
