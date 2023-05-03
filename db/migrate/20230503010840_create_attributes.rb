class CreateAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :attributes do |t|
      t.string :name, null: false
      t.string :description
      t.text   :block, null: false

      t.timestamps
    end

    add_reference :attributes, :transformation, null: false
  end
end
