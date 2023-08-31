# frozen_string_literal: true

class HarvestReport < ApplicationRecord
  belongs_to :pipeline_job
  belongs_to :harvest_job

  STATUSES = %w[queued cancelled running completed errored].freeze

  enum :extraction_status,     STATUSES, prefix: :extraction

  enum :transformation_status, STATUSES, prefix: :transformation
  enum :load_status,           STATUSES, prefix: :load

  def transformation_status
    return 'completed' if extraction_completed? && transformation_workers_queued == transformation_workers_completed

    super
  end

  def increment_pages_extracted!
    increment(:pages_extracted)
    save!
  end

  def increment_records_transformed!(amount)
    increment(:records_transformed, amount)
    save!
  end

  def increment_records_loaded!(amount)
    increment(:records_loaded, amount)
    save!
  end

  def increment_records_rejected!(amount)
    increment(:records_rejected, amount)
    save!
  end

  def increment_records_deleted!(amount)
    increment(:records_deleted, amount)
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
end
