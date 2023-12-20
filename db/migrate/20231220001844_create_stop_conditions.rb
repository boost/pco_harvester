# frozen_string_literal: true

class CreateStopConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :stop_conditions do |t|
      t.string :name
      t.text :content

      t.timestamps
    end

    add_reference :stop_conditions, :extraction_definition, null: false
  end
end
