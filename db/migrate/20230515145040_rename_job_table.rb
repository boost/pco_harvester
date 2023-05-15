class RenameJobTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :jobs, :extraction_jobs
    rename_column :transformation_definitions, :job_id, :extraction_job_id
    rename_column :harvest_definitions, :job_id, :extraction_job_id
  end
end
