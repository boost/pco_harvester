class AddStartTimeandEndTimeToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :start_time, :timestamp
    add_column :jobs, :end_time,   :timestamp
  end
end
