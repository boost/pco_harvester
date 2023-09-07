# frozen_string_literal: true

class RequestsController < ApplicationController
  def show
    @request = Request.find(params[:id])

    if params[:previous_request_id].present?
      @previous_request = Request.find(params[:previous_request_id])

      @previous_response = Extraction::DocumentExtraction.new(@previous_request).extract
    end

    render json: @request.to_h.merge(
      preview: Extraction::DocumentExtraction.new(@request, nil, @previous_response).extract
    )
  end

  def update
    @request = Request.find(params[:id])

    if @request.update(request_params)
      update_last_edited_by(@request.extraction_definition)
      render json: @request.to_h
    else
      render500
    end
  end

  private

  def request_params
    params.require(:request).permit(:http_method)
  end
end
