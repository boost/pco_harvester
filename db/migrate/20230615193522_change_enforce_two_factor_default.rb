# frozen_string_literal: true

class ChangeEnforceTwoFactorDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :enforce_two_factor, from: false, to: true
  end
end
