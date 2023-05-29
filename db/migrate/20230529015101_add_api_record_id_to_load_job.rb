class AddApiRecordIdToLoadJob < ActiveRecord::Migration[7.0]
  def change
    add_column :load_jobs, :api_record_id, :string
  end
end
