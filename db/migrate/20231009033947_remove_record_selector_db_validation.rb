# frozen_string_literal: true

class RemoveRecordSelectorDbValidation < ActiveRecord::Migration[7.0]
  def up
    change_column :transformation_definitions, :record_selector, :string, null: true
  end

  def down
    change_column :transformation_definitions, :record_selector, :string, null: false
  end
end
