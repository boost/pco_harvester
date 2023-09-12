# frozen_string_literal: true

class PipelineJob < ApplicationRecord
  include Job

  serialize :harvest_definitions_to_run, Array

  belongs_to :pipeline
  belongs_to :extraction_job, optional: true
  belongs_to :destination

  has_many :harvest_reports
  has_many :harvest_jobs, through: :harvest_reports

  enum :page_type, { all_available_pages: 0, set_number: 1 }

  validates :key, uniqueness: true

  with_options if: :set_number? do
    validates :pages, presence: true
  end
  
  def enqueue_enrichment_jobs(job_id)
    reload
    return if cancelled?
    return if pipeline.enrichments.empty?
    return unless harvest_complete?

    pipeline.enrichments.each do |enrichment|
      next unless should_run?(enrichment.id)
      next unless enrichment.ready_to_run?
      next if HarvestJob.find_by(key: "#{harvest_key}__enrichment-#{enrichment.id}").present?

      enrichment_job = HarvestJob.create(
        harvest_definition: enrichment,
        pipeline_job: self,
        key: "#{harvest_key}__enrichment-#{enrichment.id}",
        target_job_id: job_id
      )

      HarvestWorker.perform_async(enrichment_job.id)
    end
  end
  
  private

  def harvest_complete?
    harvest_reports.find_by(kind: 'harvest').complete?
  end

  def should_run?(id)
    harvest_definitions_to_run.map(&:to_i).include?(id)
  end

  def harvest_key
    return key unless key.include?('__')

    key.match(/(?<key>.+)__/)[:key]
  end
end
