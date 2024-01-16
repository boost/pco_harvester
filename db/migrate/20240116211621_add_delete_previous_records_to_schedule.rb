# frozen_string_literal: true

class AddDeletePreviousRecordsToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :delete_previous_records, :boolean, default: false, null: false
  end
end
