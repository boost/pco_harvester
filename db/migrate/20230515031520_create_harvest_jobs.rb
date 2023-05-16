class CreateHarvestJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :harvest_jobs do |t|
      t.integer 'status'
      t.integer 'kind', default: 0, null: false
      t.timestamp 'start_time'
      t.timestamp 'end_time'
      t.text 'error_message'
      t.timestamps
    end

    add_reference :harvest_jobs, :harvest_definition
  end
end
