# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_job

  has_many :fields

  validates :name, presence: true

  # Returns the records from the job based on the given record_selector
  #
  # @return Array
  def records
    return [] if record_selector.blank? || extraction_job.documents[1].nil?

    JsonPath.new(record_selector)
            .on(extraction_job.documents[1].body)
            .flatten
  end
end
