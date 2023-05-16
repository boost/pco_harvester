# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :harvest_definition
  has_one    :extraction_job
  has_one    :transformation_job
  has_one    :load_job

  delegate :content_partner, to: :harvest_definition
  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition
  delegate :destination, to: :harvest_definition
end
