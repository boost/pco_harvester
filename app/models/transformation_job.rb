# frozen_string_literal: true

# Used to store information about a Transformation Job
class TransformationJob < ApplicationRecord
  include Job

  belongs_to :transformation_definition
  belongs_to :harvest_job, optional: true
end
