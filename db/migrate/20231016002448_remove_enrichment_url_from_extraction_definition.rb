# frozen_string_literal: true

class RemoveEnrichmentUrlFromExtractionDefinition < ActiveRecord::Migration[7.0]
  def change
    remove_column :extraction_definitions, :enrichment_url, :string
  end
end
