# frozen_string_literal: true

class AddForceTwoFactorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :force_two_factor, :boolean, null: false, default: false
  end
end
