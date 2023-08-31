# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :pipeline_job
  belongs_to :harvest_definition
  belongs_to :extraction_job, optional: true
  has_many   :transformation_jobs
  has_many   :load_jobs
  has_many   :delete_jobs
  has_one    :harvest_report

  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition

  # This is to ensure that there is only ever one version of a HarvestJob running.
  # It is used when enqueing enrichments at the end of a harvest.
  validates :key, uniqueness: true

  after_create do
    self.name = "#{harvest_definition.name}__job-#{id}"
    save!
  end

  def duration_seconds
    return if extraction_job.nil? || load_jobs.empty?

    extraction_job_start_time = extraction_job.start_time
    extraction_job_end_time   = extraction_job.end_time

    transformation_jobs_start_time = transformation_jobs.minimum(:start_time)
    load_jobs_end_time = load_jobs.maximum(:end_time)

    return if transformation_jobs_start_time.nil? || extraction_job_end_time.nil?

    idle_offset = transformation_jobs_start_time - extraction_job_end_time
    idle_offset = 0 if idle_offset.negative?

    return if load_jobs_end_time.nil? || extraction_job_start_time.nil?

    (load_jobs_end_time - extraction_job_start_time) - idle_offset
  end

  def transformation_and_load_duration_seconds
    return if transformation_jobs.empty? || load_jobs.empty?

    start_time = transformation_jobs.minimum(:start_time)
    end_time = load_jobs.maximum(:end_time)
    return if end_time.nil? || start_time.nil?

    end_time - start_time
  end

  # def errored?
  #   extraction_job.errored? || (transformation_jobs.any?(&:errored?) && load_jobs.any?(&:errored?))
  # end

  # def cancelled?
  #   extraction_job.cancelled? || (transformation_jobs.any?(&:cancelled?) && load_jobs.any?(&:cancelled?))
  # end

  # def running?
  #   extraction_job.running? || (transformation_jobs.any?(&:running?) && load_jobs.any?(&:running?))
  # end

  # def completed?
  #   return false unless extraction_job.completed?
  #   return false unless transformation_jobs.where.not(status: 'completed').empty?

  #   load_jobs.where.not(status: 'completed').empty?
  # end

  # def harvest_complete?
  #   extraction_job.reload && transformation_jobs.each(&:reload) && load_jobs.each(&:reload)

  #   completed?
  # end
end
