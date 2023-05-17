# frozen_string_literal: true

class AddDefaultsOnStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_default :harvest_jobs, :status, from: nil, to: 0
    change_column_default :transformation_jobs, :status, from: nil, to: 0
    change_column_default :load_jobs, :status, from: nil, to: 0
  end
end
