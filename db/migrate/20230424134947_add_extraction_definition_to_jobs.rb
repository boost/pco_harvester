class AddExtractionDefinitionToJobs < ActiveRecord::Migration[7.0]
  def change
    change_column_default :jobs, :status, from: nil, to: 'queued'

    add_reference :jobs, :extraction_definition, null: false
  end
end
