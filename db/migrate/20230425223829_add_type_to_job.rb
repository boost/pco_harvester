class AddTypeToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :kind, :string, null: false, default: 'full'
  end
end
