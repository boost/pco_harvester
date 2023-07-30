class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.timestamps
    end
    
    add_reference :requests, :extraction_definition, null: false
  end
end
