# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :harvest_definition
  belongs_to :extraction_job, optional: true
  has_many   :transformation_jobs
  has_many   :load_jobs

  delegate :content_partner, to: :harvest_definition
  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition
  delegate :destination, to: :harvest_definition

  after_create do
    self.name = "#{harvest_definition.name}__#{self.class.to_s.underscore.dasherize}__#{id}"
    save!
  end

  def duration_seconds
    return if extraction_job.nil? || load_jobs.empty?

    end_time = load_jobs.maximum(:end_time)
    start_time = extraction_job.start_time
    return if end_time.nil? || start_time.nil?

    end_time - start_time
  end

  def transformation_and_load_duration_seconds
    return if transformation_jobs.empty? || load_jobs.empty?

    start_time = transformation_jobs.minimum(:start_time)
    end_time = load_jobs.maximum(:end_time)
    return if end_time.nil? || start_time.nil?

    end_time - start_time
  end
end
