# frozen_string_literal: true

# Used to store information about a Transformation Job
class TransformationJob < ApplicationRecord
  include Job

  belongs_to :extraction_job
  belongs_to :transformation_definition
  belongs_to :harvest_job, optional: true

  after_create do
    self.name = "#{transformation_definition.name}__job-#{id}"
    save!
  end

  def records(page = 1)
    Transformation::RawRecordsExtractor.new(transformation_definition, extraction_job).records(page)
  end
end
