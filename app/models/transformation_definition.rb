# frozen_string_literal: true

class TransformationDefinition < ApplicationRecord
  belongs_to :content_partner  
  belongs_to :job

  has_many :fields

  validates :name, presence: true

  # Returns the records from the job based on the given record_selector
  #
  # @return Array
  def records
    return [] if record_selector.blank? || job.documents[1].nil?

    JsonPath.new(record_selector)
            .on(job.documents[1].body)
            .flatten
  end

  # Returns the records from the job having applied the fields in the transformation
  #
  # @return Array 
  def transformed_records
    records.map do |record|
      fields.each_with_object({}) do |field, transformed_record|
        transformed_record[field.name] = Transformation::Execution.new(record, field).call
      end
    end
  end
 end
