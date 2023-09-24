class AddUniquenessConstraintToDefinitionName < ActiveRecord::Migration[7.0]
  def change
    add_index :extraction_definitions, :name, unique: true, length: 255
    add_index :transformation_definitions, :name, unique: true, length: 255
    add_index :pipelines, :name, unique: true, length: 255
  end
end
