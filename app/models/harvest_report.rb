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
    # extraction_completed? && transformation_completed? && load_completed? && delete_completed?
    extraction_completed? && transformation_completed? && load_completed?
  end

  # TODO
  # Refactor generating these methods

  ## These queries are all done atomically on the database
  # To prevent race conditions when multiple sidekiq processes are updating the same report at the same time.

  def increment_pages_extracted!
    HarvestReport.where(id: id).update_all("pages_extracted = pages_extracted + 1")
  end

  def increment_records_transformed!(amount)
    HarvestReport.where(id: id).update_all("records_transformed = records_transformed + #{amount}")
  end

  def increment_records_loaded!
    HarvestReport.where(id: id).update_all("records_loaded = records_loaded + 1")
  end

  def increment_records_rejected!(amount)
    HarvestReport.where(id: id).update_all("records_rejected = records_rejected + #{amount}")
  end

  def increment_records_deleted!
    HarvestReport.where(id: id).update_all("records_deleted = records_deleted + 1")
  end

  def increment_transformation_workers_queued!
    HarvestReport.where(id: id).update_all("transformation_workers_queued = transformation_workers_queued + 1")
  end

  def increment_transformation_workers_completed!
    HarvestReport.where(id: id).update_all("transformation_workers_completed = transformation_workers_completed + 1")
  end
  
  def increment_load_workers_queued!
    HarvestReport.where(id: id).update_all("load_workers_queued = load_workers_queued + 1")
  end

  def increment_load_workers_completed!
    HarvestReport.where(id: id).update_all("load_workers_completed = load_workers_completed + 1")
  end
  
  def increment_delete_workers_queued!
    HarvestReport.where(id: id).update_all("delete_workers_queued = delete_workers_queued + 1")
  end

  def increment_delete_workers_completed!
    HarvestReport.where(id: id).update_all("delete_workers_completed = delete_workers_completed + 1")
  end
end
