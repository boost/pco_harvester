class CreateExtractionDefinitionTable < ActiveRecord::Migration[7.0]
  def change
    create_table :extraction_definitions do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :extraction_definitions, :name, unique: true
  end
end
