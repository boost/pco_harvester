# frozen_string_literal: true

class Pipeline < ApplicationRecord
  paginates_per 19 # not 20 because of the "Create new pipeline" button

  has_many :harvest_definitions, dependent: :destroy
  has_many :harvest_jobs, through: :harvest_definitions
  belongs_to :last_edited_by, class_name: 'User', optional: true

  has_many :pipeline_jobs, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :name, presence: true, uniqueness: true

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
