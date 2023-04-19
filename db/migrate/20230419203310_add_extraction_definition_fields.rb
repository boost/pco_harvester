class AddExtractionDefinitionFields < ActiveRecord::Migration[7.0]
  def change
    change_table :extraction_definitions do |t|
      t.string :format, null: false
      t.string :base_url, null: false

      t.integer :throttle

      # pagination parameters
      t.string :pagination_type, null: false
      t.string :page_parameter
      t.string :per_page_parameter
      t.integer :page
      t.integer :per_page

      # how to stop
      t.string :total_selector
    end
  end
end
