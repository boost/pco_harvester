class CreateDestinations < ActiveRecord::Migration[7.0]
  def change
    create_table :destinations do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :api_key, null: false

      t.timestamps
    end
  end
end
