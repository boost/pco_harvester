class CreateLoadJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :load_jobs do |t|
      t.integer 'status'
      t.integer 'kind', default: 0, null: false
      t.timestamp 'start_time'
      t.timestamp 'end_time'
      t.integer 'records_sent_to_api', default: 0
      t.timestamps
    end

    add_reference :load_jobs, :harvest_job
  end
end
