# frozen_string_literal: true

class ChangeOwnerHarvestJobExtractionJob < ActiveRecord::Migration[7.0]
  def change
    remove_reference :extraction_jobs, :harvest_job
    add_reference :harvest_jobs, :extraction_job
  end
end
