# frozen_string_literal: true

class Pipeline < ApplicationRecord
  paginates_per 19 # not 20 because of the "Create new pipeline" button

  has_many :harvest_definitions, dependent: :destroy
  has_many :harvest_jobs, through: :harvest_definitions
  belongs_to :last_edited_by, class_name: 'User', optional: true

  has_many :pipeline_jobs, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.search(words, format)
    words = sanitize_sql_like(words || '')
    return by_format(format) if words.empty?

    words = "%#{words}%"
    users = User.select(:id).where('username LIKE ?', words)

    where('name LIKE ?', words)
      .or(where('description LIKE ?', words))
      .or(where(last_edited_by: users))
      .or(by_format(format))
  end

  def self.by_format(format)
    return self if format.blank?

    pipeline_ids = ExtractionDefinition.where(format:).pluck(:pipeline_id)
    where(id: pipeline_ids)
  end

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
