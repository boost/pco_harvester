# frozen_string_literal: true

class RequestsController < ApplicationController
  include LastEditedBy

  def show
    @request = Request.find(params[:id])

    return harvest_request if @request.extraction_definition.harvest?

    enrichment_request
  end

  def update
    @request = Request.find(params[:id])

    if @request.update(request_params)
      update_last_edited_by([@request.extraction_definition])
      render json: @request.to_h
    else
      render500
    end
  end

  private

  def harvest_request
    if params[:previous_request_id].present?
      @previous_request = Request.find(params[:previous_request_id])

      @previous_response = Extraction::DocumentExtraction.new(@previous_request).extract
    end

    render json: @request.to_h.merge(
      preview: Extraction::DocumentExtraction.new(@request, nil, @previous_response).extract
    )
  end

  def enrichment_request
    response = Extraction::RecordExtraction.new(@request, 1).extract
    record   = Extraction::ApiResponse.new(response).record(0)

    if @request.first_request?
      render json: @request.to_h.merge(
        preview: response
      )
    else
      render json: @request.to_h.merge(
        preview: Extraction::EnrichmentExtraction.new(@request, record).extract
      )
    end
  end

  def request_params
    params.require(:request).permit(:http_method)
  end
end
