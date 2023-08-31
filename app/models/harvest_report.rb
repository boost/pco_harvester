# frozen_string_literal: true

class HarvestReport < ApplicationRecord
  belongs_to :pipeline_job
  belongs_to :harvest_job

  STATUSES = %w[queued cancelled running completed errored].freeze

  enum :extraction_status,     STATUSES, prefix: :extraction
  enum :transformation_status, STATUSES, prefix: :transformation
  enum :load_status,           STATUSES, prefix: :load
  enum :delete_status,         STATUSES, prefix: :delete

  METRICS = %w[
    pages_extracted 
    records_transformed 
    records_loaded 
    records_rejected 
    records_deleted
    transformation_workers_queued
    transformation_workers_completed
    load_workers_queued
    load_workers_completed
    delete_workers_queued
    delete_workers_completed
  ]

  def complete?
    reload
    # TODO do we need to know if the delete is completed in order to queue the enrichments?
    # extraction_completed? && transformation_completed? && load_completed? && delete_completed?
    extraction_completed? && transformation_completed? && load_completed?
  end

  ## These queries are all done atomically on the database
  # To prevent race conditions when multiple sidekiq processes are updating the same report at the same time.
  METRICS.each do |metric|
    define_method("increment_#{metric}!") do |amount = 1|
      HarvestReport.where(id: id).update_all("#{metric} = #{metric} + #{amount}")
    end
  end
end
