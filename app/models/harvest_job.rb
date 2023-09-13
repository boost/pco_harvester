# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :harvest_definition
  belongs_to :destination
  belongs_to :extraction_job, optional: true
  has_many   :transformation_jobs, dependent: :restrict_with_exception
  has_many   :load_jobs, dependent: :restrict_with_exception
  has_many   :delete_jobs, dependent: :restrict_with_exception

  delegate :pipeline, to: :harvest_definition
  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition

  serialize :harvest_definitions_to_run, Array

  enum :page_type, { all_available_pages: 0, set_number: 1 }

  # This is to ensure that there is only ever one version of a HarvestJob running.
  # It is used when enqueing enrichments at the end of a harvest.
  validates :key, uniqueness: true

  after_create do
    self.name = "#{harvest_definition.name}__job-#{id}"
    save!
  end

  def duration_seconds
    return unless duration_seconds?

    (load_jobs_end_time - extraction_job.start_time) - idle_offset
  end

  def duration_seconds?
    return false if extraction_job.nil? || load_jobs.empty?
    return false if extraction_job.start_time.nil? || extraction_job.end_time.nil?
    return false if transformation_jobs_start_time.nil? || load_jobs_end_time.nil?

    true
  end

  def transformation_jobs_start_time
    @transformation_jobs_start_time ||= transformation_jobs.minimum(:start_time)
  end

  def load_jobs_end_time
    @load_jobs_end_time ||= load_jobs.maximum(:end_time)
  end

  def idle_offset
    return @idle_offset if @idle_offset.present?

    @idle_offset = transformation_jobs_start_time - extraction_job.end_time
    @idle_offset = 0 if @idle_offset.negative?
    @idle_offset
  end

  def transformation_and_load_duration_seconds
    return if transformation_jobs.empty? || load_jobs.empty?

    start_time = transformation_jobs.minimum(:start_time)
    end_time = load_jobs.maximum(:end_time)
    return if end_time.nil? || start_time.nil?

    end_time - start_time
  end

  with_options if: :set_number? do
    validates :pages, presence: true
  end

  def should_run?(id)
    harvest_definitions_to_run.map(&:to_i).include?(id)
  end

  def errored?
    extraction_job.errored? || (transformation_jobs.any?(&:errored?) && load_jobs.any?(&:errored?))
  end

  def cancelled?
    extraction_job.cancelled? || (transformation_jobs.any?(&:cancelled?) && load_jobs.any?(&:cancelled?))
  end

  def running?
    extraction_job&.running? || (transformation_jobs.any?(&:running?) && load_jobs.any?(&:running?))
  end

  def completed?
    return false unless extraction_job.completed?
    return false unless transformation_jobs.where.not(status: 'completed').empty?

    load_jobs.where.not(status: 'completed').empty?
  end

  def harvest_complete?
    extraction_job.reload && transformation_jobs.each(&:reload) && load_jobs.each(&:reload)

    completed?
  end

  def enqueue_enrichment_jobs
    return if harvest_definition.enrichment?
    return if pipeline.enrichments.empty?
    return unless harvest_complete?

    pipeline.enrichments.each { |enrichment| enqueue_enrichment_job(enrichment) }
  end

  def enqueue_enrichment_job(enrichment)
    return if !should_run?(enrichment.id) || !enrichment.ready_to_run?
    return if HarvestJob.find_by(key: enrichment_key(enrichment)).present?

    enrichment_job = HarvestJob.create(
      harvest_definition: enrichment,
      destination_id: destination.id,
      key: enrichment_key(enrichment),
      target_job_id: name,
      harvest_definitions_to_run:
    )

    HarvestWorker.perform_async(enrichment_job.id)
  end

  private

  def harvest_key
    return key unless key.include?('__')

    key.match(/(?<key>.+)__/)[:key]
  end

  def enrichment_key(enrichment)
    "#{harvest_key}__enrichment-#{enrichment.id}"
  end
end
