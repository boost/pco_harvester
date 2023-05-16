module Job
  extend ActiveSupport::Concern

  STATUSES = %w[queued cancelled running completed errored].freeze

  included do
    enum :status, STATUSES

    validates :status, presence: true, inclusion: { in: STATUSES }, if: -> { status.present? }
    # TODO: transformation jobs are so fast that they get the same time (:
    # validates :end_time, comparison: { greater_than: :start_time }, if: -> { end_time.present? }
  end

  def name
    updated_at.to_fs(:light)
  end

  # Returns the number of seconds a job has been running for
  #
  # @return Integer
  def duration_seconds
    return if start_time.blank? || end_time.blank?

    end_time - start_time
  end
end
