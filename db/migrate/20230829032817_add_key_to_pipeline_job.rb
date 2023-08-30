class AddKeyToPipelineJob < ActiveRecord::Migration[7.0]
  # def change
  #   add_column :pipeline_jobs, :key, :string
  #   add_index :pipeline_jobs,  :key, unique: true
  # end

  remove_reference :harvest_definitions, :report
  remove_reference :reports, :harvest_definition
  remove_reference :pipeline_jobs, :pipeline
end
