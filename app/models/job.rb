# This may not be the best name as it could cause confusion between this 'Job History Object' and the Sidekiq 'Job' concept

class Job < ApplicationRecord
  EXTRACTIONS_FOLDER = "#{Rails.root}/extractions".freeze

  belongs_to :extraction_definition

  after_create :setup_folder

  STATUSES = %w[queued running completed errored].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }

  STATUSES.each do |status_name|
    define_method("#{status_name}?".to_sym) do
      status == status_name
    end

    define_method("mark_as_#{status_name}".to_sym) do
      update(status: status_name)
    end
  end

  def extraction_folder
    "#{EXTRACTIONS_FOLDER}/#{created_at.strftime('%Y-%m-%d_%H-%M-%S')}_-_#{id}"
  end

  def setup_folder
    if Dir.exist?(@extraction_folder)
      Dir.each_child(&:delete)
    else
      Dir.mkdir(@extraction_folder)
    end
  end

  def documents
    Extraction::Documents.new(extraction_folder)
  end
end
