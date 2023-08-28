# frozen_string_literal: true

module ExtractionReduxState
  extend ActiveSupport::Concern

  def extraction_app_state
    {
      entities: {
        requests: requests_slice,
        parameters: parameters_slice,
        appDetails: extraction_app_details_slice
      },
      ui: {
        parameters: ui_parameters_slice,
        requests: ui_requests_slice,
        appDetails: ui_extraction_app_details_slice
      },
      config: extraction_config_slice
    }.to_json
  end

  private

  def parameters_slice
    {
      ids: @parameters.map { |request| request[:id] },
      entities: @parameters.index_by { |request| request[:id] }
    }
  end

  def requests_slice
    {
      ids: @extraction_definition.requests.map { |request| request[:id] },
      entities: @extraction_definition.requests.map(&:to_h).index_by { |request| request[:id] }
    }
  end

  def extraction_app_details_slice
    {
      pipeline: @pipeline,
      harvestDefinition: @harvest_definition,
      extractionDefinition: @extraction_definition
    }
  end

  def ui_extraction_app_details_slice
    {
      activeRequest: @extraction_definition.requests.first.id
    }
  end

  def extraction_config_slice
    {
      environment: Rails.env
    }
  end

  def ui_parameters_slice
    parameter_entities = @parameters.map { |parameter| ui_parameter_entity(parameter) }

    {
      ids: @parameters.map { |parameter| parameter[:id] },
      entities: parameter_entities.index_by { |parameter| parameter[:id] }
    }
  end

  def ui_parameter_entity(parameter)
    {
      id: parameter[:id],
      saved: true,
      saving: false,
      deleting: false,
      displayed: parameter.request == @extraction_definition.requests.first
    }
  end

  def ui_requests_slice
    request_entities = @extraction_definition.requests.map { |request| ui_request_entity(request) }

    {
      ids: @extraction_definition.requests.map { |request| request[:id] },
      entities: request_entities.index_by { |request| request[:id] }
    }
  end

  def ui_request_entity(request)
    {
      id: request[:id],
      loading: false
    }
  end
end