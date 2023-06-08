# frozen_string_literal: true

module UserAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :setup_two_factor_authentication
  end

  protected

  def setup_two_factor_authentication
    excluded_paths = ['/users/sign_in', '/users/password/new', '/users/invitation', '/users/invitation/accept']
    
    return if excluded_paths.include?(request.path)
    return if current_user.two_factor_setup?

    current_user.update(otp_secret: User.generate_otp_secret) if current_user.otp_secret.nil?

    redirect_to two_factor_authentication_path
  end

  def authenticate_inviter!
    authenticate_admin!
  end

  # Having multiple redirect raises an Exception
  # devise_invitable uses authenticate_inviter! to get the inviter user
  # It makes several call to it
  # That's why we return if performed?
  def authenticate_admin!
    return current_user if current_user.admin? || performed?

    flash.alert = 'You are not authorized to access this page'
    redirect_back fallback_location: root_path
  end
end
