class RemoveUnusedColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :name
    remove_column :jobs, :result_location
  end
end
