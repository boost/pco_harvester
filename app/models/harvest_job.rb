# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :harvest_definition
  has_one    :extraction_job
  has_many   :transformation_jobs
  has_many   :load_jobs

  delegate :content_partner, to: :harvest_definition
  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition
  delegate :destination, to: :harvest_definition

  def duration_seconds
    return if extraction_job.start_time.nil? || load_jobs.empty?

    load_jobs.maximum(:end_time) - extraction_job.start_time
  end
end
