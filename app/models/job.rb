# This may not be the best name as it could cause confusion between this 'Job History Object' and the Sidekiq 'Job' concept

class Job < ApplicationRecord
  belongs_to :extraction_definition

  STATUSES = %w[
    queued running completed errored
  ].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }

  STATUSES.each do |status_name|
    define_method("#{status_name}?".to_sym) do
      status == status_name
    end

    define_method("mark_as_#{status_name}".to_sym) do
      update(status: status_name)
    end
  end
end
