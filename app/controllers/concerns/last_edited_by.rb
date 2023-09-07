# frozen_string_literal: true

module LastEditedBy
  extend ActiveSupport::Concern

  protected

  # Updates the attribute "last_edited_by" with the current user
  # The resource can be given as a parameter this method uses the
  # `last_edited_by_resources` method that can be defined in the
  # controller
  #
  # @params resource: a model having the last_edited_by attribute
  def update_last_edited_by(resource = nil)
    resources = resource || last_edited_by_resources
    resources = [resources] if resource.class != Array
    resources.each do |r|
      r.update(last_edited_by: current_user)
    end
  end

  # Helper to add the `last_edited_by_id` to the safe params
  def merge_last_edited_by(safe_params)
    safe_params.merge(last_edited_by_id: current_user.id)
  end
end
