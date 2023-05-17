# frozen_string_literal: true

class HarvestDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_definition, optional: true
  belongs_to :extraction_job, optional: true
  belongs_to :transformation_definition, dependent: :destroy
  belongs_to :destination

  has_many :harvest_jobs

  validates :name, presence: true

  before_create :clone_transformation

  def clone_transformation
    safe_transformation = transformation_definition.dup
    transformation_definition.fields.each do |field|
      safe_transformation.fields.push(field.dup)
    end
    safe_transformation.original_transformation_definition = transformation_definition
    safe_transformation.save
    self.transformation_definition = safe_transformation
  end

  def update_clone(transformation_definition)
    self.transformation_definition.destroy
    self.transformation_definition = transformation_definition
    clone_transformation
    save
  end
end
