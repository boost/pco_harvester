# frozen_string_literal: true

class AddS3FieldsToExtractionType < ActiveRecord::Migration[7.0]
  def change
    add_column :extraction_definitions, :s3, :boolean, default: false, null: false
    add_column :extraction_definitions, :s3_bucket, :string
    add_column :extraction_definitions, :s3_arguments, :string
  end
end
