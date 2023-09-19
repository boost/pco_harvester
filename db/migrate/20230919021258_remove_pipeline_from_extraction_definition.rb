class RemovePipelineFromExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    remove_reference :extraction_definitions, :pipeline
  end
end
