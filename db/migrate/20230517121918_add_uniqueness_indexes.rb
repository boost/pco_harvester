# frozen_string_literal: true

class AddUniquenessIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :transformation_definitions, %i[content_partner_id name], unique: true
    add_index :harvest_definitions, %i[content_partner_id name], unique: true
  end
end
