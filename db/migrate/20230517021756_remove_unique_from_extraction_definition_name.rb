# frozen_string_literal: true

class RemoveUniqueFromExtractionDefinitionName < ActiveRecord::Migration[7.0]
  def up
    change_column :extraction_definitions, :name, :string, unique: false
  end

  def down
    change_column :extraction_definitions, :name, :string, unique: true
    remove_index :extraction_definitions, %i[content_partner_id name], unique: true
    remove_index :extraction_definitions, :name
  end
end
