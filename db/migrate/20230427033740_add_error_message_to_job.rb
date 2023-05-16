# frozen_string_literal: true

class AddErrorMessageToJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :error_message, :text
  end
end
