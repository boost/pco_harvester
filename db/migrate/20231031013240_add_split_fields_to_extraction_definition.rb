# frozen_string_literal: true

class AddSplitFieldsToExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :split, :boolean, default: false, null: false
    add_column :extraction_definitions, :split_selector, :string
  end
end
