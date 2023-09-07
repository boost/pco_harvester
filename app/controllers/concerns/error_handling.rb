# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  protected

  def render500
    format.json { render500_json }
  end

  def render500_json
    render json: {
      error: true,
      errorCode: 'InternalServerError',
      message: 'An unexpected error occured, check logs'
    }, status: :internal_server_error
  end
end
