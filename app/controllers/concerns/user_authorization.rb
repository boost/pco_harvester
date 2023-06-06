# frozen_string_literal: true

module UserAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  protected

  def authenticate_inviter!
    raise ActionController::RoutingError.new('Not authorized') unless current_user.admin?
  end

  def authenticate_admin!
    return if current_user.admin?

    redirect_back(fallback_location: root_path, alert: 'You are not authorized to access this page')
  end
end
