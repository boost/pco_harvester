# frozen_string_literal: true

class Pipeline < ApplicationRecord
  has_many :harvest_definitions
  has_many :harvest_jobs, through: :harvest_definitions

  validates :name, presence: true

  def harvest
    harvest_definitions.find(&:harvest?)
  end

  def enrichments
    harvest_definitions.select(&:enrichment?)
  end

  def ready_to_run?
    return false if harvest_definitions.empty?

    harvest_definitions.all? { |definition| definition.ready_to_run? }
  end
end
