class AddTokenisedFieldsToExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :next_page_token_path, :string
    add_column :extraction_definitions, :token_parameter, :string
    add_column :extraction_definitions, :initial_token_value, :string
  end
end
