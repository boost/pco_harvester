# frozen_string_literal: true

# Used to store information about a Job
#
class Job < ApplicationRecord
  EXTRACTIONS_FOLDER = "#{Rails.root}/extractions/#{Rails.env}".freeze

  belongs_to :extraction_definition

  after_create :create_folder
  after_destroy :delete_folder

  STATUSES = %w[queued cancelled running completed errored].freeze
  KINDS = %w[full sample].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :end_time, comparison: { greater_than: :start_time }, if: ->{ end_time.present? }

  STATUSES.each do |status_name|
    # A helper method to determine the status of a job
    # 
    # @example job.queued? #=> true
    # @return [true, false] depending on the status of the job
    define_method("#{status_name}?".to_sym) do
      status == status_name
    end

    # A helper method to update the status of the job
    #
    # @example job.mark_as_cancelled #=> true
    # @return [true, false] depending on success of update method
    define_method("mark_as_#{status_name}".to_sym) do
      update(status: status_name)
    end
  end

  KINDS.each do |kind_name|
    # A helper method to determine the kind of job
    #
    # @example job.full? #=> true
    # @return [true, false] depending on kind of job
    define_method("#{kind_name}?".to_sym) do
      kind == kind_name
    end
  end

  # Returns the fullpath to the extraction folder for this job
  #
  # @example job.extraction_folder #=> /app/extractions/development/2023-04-28_08-51-16_-_19
  # @return String
  def extraction_folder
    "#{EXTRACTIONS_FOLDER}/#{created_at.to_fs(:file_format)}_-_#{id}"
  end

  # Creates a folder at the location of the extraction_folder
  #
  # @return [true, false] depending on success of the folder creation
  def create_folder
    Dir.mkdir(extraction_folder)
  end

  # Deletes a folder at the location of the extraction folder
  #
  # @return [true, false] depending on success of the folder deletion
  def delete_folder
    return unless Dir.exist?(extraction_folder)

    FileUtils.rm Dir.glob("#{extraction_folder}/*")
    Dir.rmdir(extraction_folder)
  end

  # Converts the files stored in the extraction folder into pageable objects
  #
  # @return Extraction::Documents object
  def documents
    Extraction::Documents.new(extraction_folder)
  end

  # Returns the number of seconds a job has been running for
  #
  # @return Integer
  def duration_seconds
    return if start_time.blank? || end_time.blank?

    end_time - start_time
  end

  # Returns the size of the extraction folder in bytes 
  #
  # @return Integer
  def extraction_folder_size_in_bytes
    `du #{extraction_folder} | cut -f1`.to_i
  end
end
