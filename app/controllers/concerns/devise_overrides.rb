# frozen_string_literal: true

module DeviseOverrides
  extend ActiveSupport::Concern

  included do
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_invite_path_for(_inviter, _invitee = nil)
    users_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[username email role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
end
