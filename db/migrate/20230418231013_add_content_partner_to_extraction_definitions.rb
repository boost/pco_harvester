class AddContentPartnerToExtractionDefinitions < ActiveRecord::Migration[7.0]
  def change
    add_reference :extraction_definitions, :content_partner, null: false
  end
end
