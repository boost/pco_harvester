class CreateAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.text   :block, null: false

      t.timestamps
    end

    add_reference :fields, :transformation, null: false
  end
end
