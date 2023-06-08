# frozen_string_literal: true

class TwoFactorAuthenticationsController < ApplicationController
  skip_before_action :setup_two_factor_authentication
  
  def show
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

  private

  def user_params
    params.require(:user).permit(:otp_attempt)
  end
end
