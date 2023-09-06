# frozen_string_literal: true

module LastEditedBy
  extend ActiveSupport::Concern

  protected

  def merge_last_edited_by(safe_params)
    safe_params.merge(last_edited_by_id: current_user.id)
  end
end
