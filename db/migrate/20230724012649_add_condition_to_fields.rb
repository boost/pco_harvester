class AddConditionToFields < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :kind, :integer, default: 0
    add_column :fields, :condition_kind, :integer, default: 0
  end
end
