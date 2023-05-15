# frozen_string_literal: true

class HarvestDefinition < ApplicationRecord
  belongs_to :content_partner
  belongs_to :extraction_definition, optional: true
  belongs_to :job, optional: true
  belongs_to :transformation_definition
  belongs_to :destination

  has_many :harvest_jobs

  validates :name, presence: true
end
