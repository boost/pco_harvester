class AddUserToPipeline < ActiveRecord::Migration[7.0]
  def change
    add_reference :pipelines, :last_edited_by, foreign_key: { to_table: :users }
  end
end
