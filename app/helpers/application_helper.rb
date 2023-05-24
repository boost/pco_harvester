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

  # If you need a new icon:
  # - Go to https://icons.getbootstrap.com/icons/
  # - Find the icon you want
  # - Copy the HTML
  # - Create a new file in "shared/icons" with the exact same name, eg: shared/icons/_4-share-fill.html.erb
  #
  # The color of the SVG can be controller with "color" CSS property
  # The size of it is 1em -> it will match the font-size
  def bootstrap_icon(name, **html_attributes)
    render("shared/icons/#{name}", locals: html_attributes)
  end
end
