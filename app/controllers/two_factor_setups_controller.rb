# frozen_string_literal: true

class TwoFactorSetupsController < ApplicationController
  skip_before_action :setup_two_factor_authentication

  def show
    current_user.update(otp_secret: User.generate_otp_secret) if current_user.otp_secret.nil?
  end

  def create
    if current_user.validate_and_consume_otp!(user_params[:otp_attempt])
      current_user.update(otp_required_for_login: true, two_factor_setup: true)

      flash.notice = 'Two Factor Authentication successfully set up'
      redirect_to root_path
    else
      flash.alert = 'Two Factor Authentication failed. Please try and input your code again.'
      render :show
    end
  end

  def destroy
    if current_user.enforce_two_factor?
      return redirect_back fallback_location: root_path, alert: '2FA was made mandatory for you by admins'
    end

    if current_user.update(otp_required_for_login: false, otp_secret: nil, two_factor_setup: false)
      flash.notice = 'Two Factor Authentication successfully disabled.'
    else
      flash.alert = 'There was a problem disabling 2FA.'
    end

    redirect_to edit_profile_path
  end

  private

  def user_params
    params.require(:user).permit(:otp_attempt)
  end
end
