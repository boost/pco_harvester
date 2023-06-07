# frozen_string_literal: true

class TwoFactorAuthenticationsController < ApplicationController
  def show
  end

  def create
    if current_user.validate_and_consume_otp!(user_params[:otp_attempt])
      current_user.otp_required_for_login = true
      current_user.save!
    else
      flash.alert = 'Failed to setup Two Factor Authentication'

      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:otp_attempt)
  end
end
