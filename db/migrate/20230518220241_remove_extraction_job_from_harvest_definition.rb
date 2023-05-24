# frozen_string_literal: true

class RemoveExtractionJobFromHarvestDefinition < ActiveRecord::Migration[7.0]
  def change
    remove_reference :harvest_definitions, :extraction_job
  end
end
