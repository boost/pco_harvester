# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  belongs_to :harvest_definition
end
