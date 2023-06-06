# frozen_string_literal: true

module UserAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  protected

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
