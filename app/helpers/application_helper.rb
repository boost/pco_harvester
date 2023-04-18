module ApplicationHelper
  def current_page(controller, actions)
    controller_name == controller.to_s && action_name.in?(actions)
  end
end
