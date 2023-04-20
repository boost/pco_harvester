class CreateExtractionDefinitionTable < ActiveRecord::Migration[7.0]
  def change
    create_table :extraction_definitions do |t|
      t.string :name, null: false
      t.string :format, null: false
      t.string :base_url, null: false
      t.integer :throttle, null: false, default: 0

      # pagination parameters
      t.string :pagination_type, null: false
      t.string :page_parameter
      t.string :per_page_parameter
      t.integer :page
      t.integer :per_page
      t.string :total_selector

      t.timestamps
    end

    add_reference :extraction_definitions, :content_partner, null: false

    add_index :extraction_definitions, :name
    add_index :extraction_definitions, %i[content_partner_id name], unique: true
  end
end
