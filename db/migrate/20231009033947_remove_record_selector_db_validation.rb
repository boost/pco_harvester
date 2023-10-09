class RemoveRecordSelectorDbValidation < ActiveRecord::Migration[7.0]
  def change
    change_column :transformation_definitions, :record_selector, :string, null: true
  end
end
