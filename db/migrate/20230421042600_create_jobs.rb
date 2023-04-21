class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :name
      t.string :status
      t.string :result_location

      t.timestamps
    end
  end
end
