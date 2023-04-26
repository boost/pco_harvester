
class Job < ApplicationRecord
  EXTRACTIONS_FOLDER = "#{Rails.root}/extractions".freeze

  belongs_to :extraction_definition

  after_create :create_folder
  after_destroy :delete_folder

  STATUSES = %w[queued cancelled running completed errored].freeze
  KINDS = %w[full sample].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :kind, presence: true, inclusion: { in: KINDS }

  STATUSES.each do |status_name|
    define_method("#{status_name}?".to_sym) do
      status == status_name
    end

    define_method("mark_as_#{status_name}".to_sym) do
      update(status: status_name)
    end
  end

  KINDS.each do |kind_name|
    define_method("#{kind_name}?".to_sym) do
      kind == kind_name
    end
  end

  def extraction_folder
    "#{EXTRACTIONS_FOLDER}/#{created_at.strftime('%Y-%m-%d_%H-%M-%S')}_-_#{id}"
  end

  def create_folder
    Dir.mkdir(extraction_folder)
  end

  def delete_folder
    FileUtils.rm Dir.glob("#{extraction_folder}/*")
    Dir.rmdir(extraction_folder)
  end

  def documents
    Extraction::Documents.new(extraction_folder)
  end
end
