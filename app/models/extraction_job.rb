# frozen_string_literal: true

# Used to store information about a Job
#
class ExtractionJob < ApplicationRecord
  include Job

  EXTRACTIONS_FOLDER = "#{Rails.root}/extractions/#{Rails.env}".freeze
  KINDS = %w[full sample].freeze

  enum :kind, KINDS, prefix: :is

  belongs_to :extraction_definition
  belongs_to :harvest_job, optional: true

  after_create :create_folder
  after_destroy :delete_folder

  validates :kind, presence: true, inclusion: { in: KINDS }, if: -> { kind.present? }

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

  # Returns the size of the extraction folder in bytes
  #
  # @return Integer
  def extraction_folder_size_in_bytes
    `du #{extraction_folder} | cut -f1`.to_i
  end
end
