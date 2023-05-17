class RenameTransformations < ActiveRecord::Migration[7.0]
  def change
    remove_index :transformations, %i[content_partner_id job_id], unique: true
    rename_table :transformations, :transformation_definitions
    rename_column :fields, :transformation_id, :transformation_definition_id
  end
end
