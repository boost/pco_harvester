class CreateHarvestDefinitions < ActiveRecord::Migration[7.0]
  def change
    create_table :harvest_definitions do |t|
      t.string :name
      t.timestamps
    end

    add_reference :harvest_definitions, :content_partner
    add_reference :harvest_definitions, :extraction_definition
    add_reference :harvest_definitions, :job
    add_reference :harvest_definitions, :transformation_definition
    add_reference :harvest_definitions, :destination
  end
end
