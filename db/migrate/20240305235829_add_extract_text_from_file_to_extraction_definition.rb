class AddExtractTextFromFileToExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :extract_text_from_file, :boolean, default: false, null: false
    add_column :extraction_definitions, :extracted_file_format, :string
  end
end
