class ChangeJobKindToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :kind, :integer, default: 0
  end
end
