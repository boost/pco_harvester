# frozen_string_literal: true

class Transformation < ApplicationRecord
  belongs_to :content_partner  
  belongs_to :job

  validates :name, presence: true

  def records
    return [] if job.documents[1].nil?

    JsonPath.new(record_selector)
            .on(job.documents[1].body)
            .flatten
  end
 end
