class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.string  :frequency
      t.integer :hour
      t.integer :minutes

      t.timestamps
    end
    
    add_reference :schedules, :pipeline, null: false
    add_reference :schedules, :destination
  end
end
