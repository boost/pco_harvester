# frozen_string_literal: true

class AddExtractionJobToTransformationJob < ActiveRecord::Migration[7.0]
  def change
    add_reference :transformation_jobs, :extraction_job
  end
end
