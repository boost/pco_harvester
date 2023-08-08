# frozen_string_literal: true

class RequestsController < ApplicationController
  def update
    @request = Request.find(params[:id])

    @request.update!(request_params)

    render json: @request.to_h
  end

  def show
    @request = Request.find(params[:id])

    if params[:previous_request_id].present?
      @previous_request = Request.find(params[:previous_request_id])
      @previous_response_body = Extraction::DocumentExtraction.new(@previous_request).extract.body
    end
    
    render json: @request.to_h.merge(
      preview: Extraction::DocumentExtraction.new(@request, nil, @previous_response_body).extract
    )
  end

  private

  def request_params
    params.require(:request).permit(:http_method)
  end
end
