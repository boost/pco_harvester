# frozen_string_literal: true

class TwoFactorSetUp < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :two_factor_setup, :boolean, default: false, null: false
  end
end
