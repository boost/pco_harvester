# frozen_string_literal: true

class HarvestReport < ApplicationRecord
  belongs_to :pipeline_job
  belongs_to :harvest_job

  STATUSES = %w[queued cancelled running completed errored].freeze

  enum :extraction_status,     STATUSES, prefix: :extraction
  enum :transformation_status, STATUSES, prefix: :transformation
  enum :load_status,           STATUSES, prefix: :load
  enum :delete_status,         STATUSES, prefix: :delete

  def complete?
    reload
    extraction_completed? && transformation_completed? && load_completed? && delete_completed?
  end

  def increment_pages_extracted!
    increment(:pages_extracted)
    save!
  end

  def increment_records_transformed!(amount)
    increment(:records_transformed, amount)
    save!
  end

  def increment_records_loaded!
    increment(:records_loaded)
    save!
  end

  def increment_records_rejected!(amount)
    increment(:records_rejected, amount)
    save!
  end

  def increment_records_deleted!
    increment(:records_deleted)
    save!
  end

  def increment_transformation_workers_queued!
    increment(:transformation_workers_queued)
    save!
  end

  def increment_transformation_workers_completed!
    increment(:transformation_workers_completed)
    save!
  end
  
  def increment_load_workers_queued!
    increment(:load_workers_queued)
    save!
  end

  def increment_load_workers_completed!
    increment(:load_workers_completed)
    save!
  end
  
  def increment_delete_workers_queued!
    increment(:delete_workers_queued)
    save!
  end

  def increment_delete_workers_completed!
    increment(:delete_workers_completed)
    save!
  end
end
