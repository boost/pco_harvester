# frozen_string_literal: true

module ApplicationHelper
  def current_page(controller, actions)
    controller_name == controller.to_s && action_name.in?(actions)
  end

  def breadcrumb_item(text:, path: nil, display: true, active: false)
    return unless display

    tag.li(class: { 'breadcrumb-item': true, active: }) do
      path && !active ? link_to(text, path) : text&.to_s
    end
  end
end
