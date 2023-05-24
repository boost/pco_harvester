# frozen_string_literal: true

class AddUniqueFromExtractionDefinitionName < ActiveRecord::Migration[7.0]
  def up
    change_column :extraction_definitions, :name, :string, unique: true
  end

  def down
    change_column :extraction_definitions, :name, :string, unique: false
  end
end
