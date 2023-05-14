# frozen_string_literal: true

class HarvestDefinition < ApplicationRecord

  belongs_to :extraction_definition
  belongs_to :job
  belongs_to :transformation_definition
  belongs_to :destination
  
end
