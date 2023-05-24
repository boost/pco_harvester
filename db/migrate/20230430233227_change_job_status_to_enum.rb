# frozen_string_literal: true

class ChangeJobStatusToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column :jobs, :status, :integer, default: 0
  end
end
