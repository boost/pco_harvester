class AddTokenisedFieldsToExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :next_page_token_location, :string
    add_column :extraction_definitions, :initial_param, :string
  end
end
