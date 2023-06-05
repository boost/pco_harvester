# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def paginate_and_filter_jobs(jobs)
    @status = params[:status]
    jobs = jobs.order(updated_at: :desc).page(params[:page])
    jobs = jobs.where(status: @status) if @status

    jobs
  end

  def after_invite_path_for(_inviter, _invitee = nil)
    users_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: %i[username email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username])
  end
end
