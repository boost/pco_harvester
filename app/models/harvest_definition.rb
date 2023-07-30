# frozen_string_literal: true

class HarvestDefinition < ApplicationRecord
  belongs_to :pipeline
  belongs_to :content_source, optional: true

  belongs_to :extraction_definition, optional: true, dependent: :destroy
  belongs_to :extraction_job, optional: true

  belongs_to :transformation_definition, dependent: :destroy, optional: true

  has_many :harvest_jobs, dependent: :destroy

  validates :source_id, presence: true

  enum :kind, { harvest: 0, enrichment: 1 }

  after_create do
    self.name = "#{pipeline.name.parameterize}__#{kind}-#{id}"
    save!
  end

  def ready_to_run?
    return false if extraction_definition.blank?
    return false if transformation_definition.blank?
    return false if transformation_definition.fields.empty?

    true
  end
end
