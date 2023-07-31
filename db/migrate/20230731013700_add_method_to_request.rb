class AddMethodToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :method, :string
  end
end
