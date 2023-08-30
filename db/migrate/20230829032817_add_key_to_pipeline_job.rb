class AddKeyToPipelineJob < ActiveRecord::Migration[7.0]
  def change
    add_column :pipeline_jobs, :key, :string
    add_index :pipeline_jobs,  :key, unique: true
  end

  add_reference :harvest_definitions, :report
  add_reference :reports, :harvest_definition
  add_reference :pipeline_jobs, :pipeline
end
