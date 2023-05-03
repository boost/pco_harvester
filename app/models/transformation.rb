# frozen_string_literal: true

class Transformation < ApplicationRecord
  belongs_to :content_partner  
  belongs_to :job

  validates :name, presence: true

  def records
    return [] if record_selector.blank? || job.documents[1].nil?

    JsonPath.new(record_selector)
            .on(job.documents[1].body)
            .flatten
  end

  def transformed_records
    # TODO rename attribute class as it conflicts with 
    # the attributes method from active record :(

    # Very basic initial implementation

    records.map do |record|
      Attribute.where(transformation_id: id).each_with_object({}) do |attribute, hash|
        block = ->(record) { eval(attribute.block) }

        hash[attribute.name] = block.call(record)
      end
    end
    
  end
 end
