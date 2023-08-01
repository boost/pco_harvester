# frozen_string_literal: true

module ExtractionReduxState
  extend ActiveSupport::Concern

  def extraction_app_state
    {
      entities: {
        requests: requests_slice,
        parameters: parameters_slice, 
        appDetails: app_details_slice
      },
      ui: {
        parameters: ui_parameters_slice
      },
      config: config_slice
    }.to_json
  end

  private

  def parameters_slice
    {
      ids: @extraction_definition.parameters.map { |request| request[:id] },
      entities: @extraction_definition.parameters.index_by { |request| request[:id] }
    }
  end

  def requests_slice
    {
      ids: @extraction_definition.requests.map { |request| request[:id] },
      entities: @extraction_definition.requests.index_by { |request| request[:id] },
    }
  end

  def app_details_slice
    {
      pipeline: @pipeline,
      harvestDefinition: @harvest_definition,
      extractionDefinition: @extraction_definition,
      request: @extraction_definition.requests.first
    }
  end

  def config_slice
    {
      environment: Rails.env
    }
  end

  def ui_parameters_slice
    parameter_entities = @extraction_definition.parameters.map { |parameter| ui_parameter_entity(parameter) }
    {
      ids: @extraction_definition.parameters.map { |parameter| parameter[:id] },
      entities: parameter_entities.index_by { |parameter| parameter[:id] }
    }
  end
  
  def ui_parameter_entity(parameter)
    {
      id: parameter[:id],
      saved: true, 
      saving: false,
      deleting: false,
      displayed: false
    }
  end
end
