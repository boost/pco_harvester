# frozen_string_literal: true

class RenameForceTwoFactor < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :force_two_factor, :enforce_two_factor
  end
end
