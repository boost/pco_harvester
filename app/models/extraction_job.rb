# frozen_string_literal: true

# Used to store information about a Job
#
class ExtractionJob < ApplicationRecord
  EXTRACTIONS_FOLDER = "#{Rails.root}/extractions/#{Rails.env}".freeze
  STATUSES = %w[queued cancelled running completed errored].freeze
  KINDS = %w[full sample].freeze

  enum :status, STATUSES
  enum :kind, KINDS, prefix: :is

  belongs_to :extraction_definition

  after_create :create_folder
  after_destroy :delete_folder

  validates :status, presence: true, inclusion: { in: STATUSES }, if: -> { status.present? }
  validates :kind, presence: true, inclusion: { in: KINDS },      if: -> { kind.present? }
  validates :end_time, comparison: { greater_than: :start_time }, if: -> { end_time.present? }

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

  def name
    updated_at.to_fs(:light)
  end
end
