# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  protected

  def render_bad_request(resource)
    render_bad_request_json(resource)
  end

  def render500
    format.html { render500_html }
    format.json { render500_json }
  end

  def render500_html
    # to be implemented if needed
  end

  def render500_json
    render json: {
      error: true,
      errorCode: 'InternalServerError',
      message: 'An unexpected error occured, check logs'
    }, status: :internal_server_error
  end
end
