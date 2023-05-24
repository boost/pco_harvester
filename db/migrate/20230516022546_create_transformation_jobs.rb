# frozen_string_literal: true

class CreateTransformationJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :transformation_jobs do |t|
      t.integer 'status'
      t.integer 'kind', default: 0, null: false
      t.integer 'page'
      t.timestamp 'start_time'
      t.timestamp 'end_time'
      t.text 'error_message'
      t.integer 'records_transformed', default: 0

      t.timestamps
    end

    add_reference :transformation_jobs, :transformation_definition
    add_reference :transformation_jobs, :harvest_job
  end
end
