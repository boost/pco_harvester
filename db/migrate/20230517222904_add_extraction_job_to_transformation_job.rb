class AddExtractionJobToTransformationJob < ActiveRecord::Migration[7.0]
  def change
    add_reference :transformation_jobs, :extraction_job
  end
end
