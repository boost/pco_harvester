# frozen_string_literal: true

class AddDeletePreviousToPipelineJob < ActiveRecord::Migration[7.0]
  def change
    add_column :pipeline_jobs, :delete_previous_records, :boolean, default: false, null: false
  end
end
