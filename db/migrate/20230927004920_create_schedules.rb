class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.integer :frequency, default: 0
      t.string  :time
      t.integer  :day
      t.string  :harvest_definitions_to_run
      t.integer :day_of_the_month

      t.timestamps
    end
    
    add_reference :schedules, :pipeline, null: false
    add_reference :schedules, :destination
  end
end
