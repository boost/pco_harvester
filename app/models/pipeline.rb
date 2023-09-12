# frozen_string_literal: true

class Pipeline < ApplicationRecord
  has_many :harvest_definitions, dependent: :restrict_with_exception
  has_many :harvest_jobs, through: :harvest_definitions

  has_many :pipeline_jobs, dependent: :destroy

  validates :name, presence: true

  def harvest
    harvest_definitions.find_by(kind: 'harvest')
  end

  def enrichments
    harvest_definitions.where(kind: 'enrichment')
  end

  def ready_to_run?
    return false if harvest_definitions.empty?

    harvest_definitions.any?(&:ready_to_run?)
  end
end
