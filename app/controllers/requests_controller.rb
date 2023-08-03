# frozen_string_literal: true

class RequestsController < ApplicationController
  def update
    @request = Request.find(params[:id])

    @request.update!(request_params)

    render json: @request.to_h
  end

  def show
    @request = Request.find(params[:id])

    render json: @request.to_h.merge(
      preview: Extraction::DocumentExtraction.new(@request).extract
    )
  end

  private

  def request_params
    params.require(:request).permit(:http_method)
  end
end
