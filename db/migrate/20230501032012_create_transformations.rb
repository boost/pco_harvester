class CreateTransformations < ActiveRecord::Migration[7.0]
  def change
    create_table :transformations do |t|
      t.string :name, null: false
      t.string :record_selector, null: false

      t.timestamps
    end

    add_reference :transformations, :content_partner, null: false
    add_reference :transformations, :job,             null: false

    add_index :transformations, :name
    add_index :transformations, %i[content_partner_id job_id], unique: true
  end
end
