# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :extraction_job # used for previewing, needs to be refactored
  belongs_to :pipeline

  has_many :fields

  scope :originals, -> { where(original_transformation_definition: nil) }

  enum :kind, { harvest: 0, enrichment: 1 }

  validates :record_selector, presence: true

  after_create do
    self.name = "#{pipeline.name.parameterize}__#{kind}-transformation-#{id}"
    save!
  end

  # Returns the records from the job based on the given record_selector
  # Used for previewing, needs to be refactored
  #
  # @return Array
  def records(page = 1)
    return [] if record_selector.blank? || extraction_job.documents[page].nil?

    if extraction_job.extraction_definition.format == 'HTML'
      Nokogiri::HTML(extraction_job.documents[page].body)
        .xpath(record_selector)
        .map(&:to_xml)
    elsif extraction_job.extraction_definition.format == 'XML'
      Nokogiri::XML(extraction_job.documents[page].body)
        .xpath(record_selector)
        .map(&:to_xml)
    elsif extraction_job.extraction_definition.format == 'JSON'
      JsonPath.new(record_selector)
              .on(extraction_job.documents[page].body)
              .flatten
    end
  end

  def to_h
    {
      id: id,
      name: name
    }
  end
end
