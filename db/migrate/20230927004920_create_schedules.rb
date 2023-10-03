class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.string  :name
      t.integer :frequency, default: 0
      t.string  :time
      t.integer :day
      t.string  :harvest_definitions_to_run
      t.integer :day_of_the_month
      t.integer :bi_monthly_day_one
      t.integer :bi_monthly_day_two

      t.timestamps
    end
    
    add_reference :schedules, :pipeline, null: false
    add_reference :schedules, :destination
    add_reference :pipeline_jobs, :schedule
    add_reference :pipeline_jobs, :launched_by
    add_index :schedules, %i[name], unique: true
  end
end
