class AddHeadersToExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :headers, :text
  end
end
