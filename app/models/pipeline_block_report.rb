# frozen_string_literal: true

class PipelineBlockReport < ApplicationRecord
  belongs_to :pipeline_job
  
  STATUSES = %w[queued cancelled running completed errored].freeze

  enum :extraction_status,     STATUSES, prefix: :extraction
  enum :transformation_status, STATUSES, prefix: :transformation
  enum :load_status,           STATUSES, prefix: :load

  def increment_pages_extracted!
    increment(:pages_extracted)
  end

  def increment_records_transformed!
    increment(:records_transformed)
  end

  def increment_records_loaded!
    increment(:records_loaded)
  end

  def increment_records_rejected!
    increment(:records_rejected)
  end

  def increment_records_deleted!
    increment(:records_deleted)
  end
end
