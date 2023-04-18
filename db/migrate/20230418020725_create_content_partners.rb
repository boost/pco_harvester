class CreateContentPartners < ActiveRecord::Migration[7.0]
  def change
    create_table :content_partners do |t|
      t.string :name

      t.timestamps
    end
  end
end
