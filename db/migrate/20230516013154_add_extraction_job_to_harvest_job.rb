class AddExtractionJobToHarvestJob < ActiveRecord::Migration[7.0]
  def change
    add_reference :extraction_jobs, :harvest_job
  end
end
