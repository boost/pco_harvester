# frozen_string_literal: true

module TransformationReduxState
  extend ActiveSupport::Concern

  def transformation_app_state
    {
      entities: {
        fields: fields_slice, rawRecord: raw_record_slice,
        appDetails: app_details_slice, sharedDefinitions: shared_definitions_slice
      },
      ui: {
        fields: ui_fields_slice, appDetails: ui_app_details_slice
      },
      config: config_slice
    }.to_json
  end

  private

  def fields_slice
    {
      ids: @fields.pluck(:id),
      entities: @fields.index_by { |field| field[:id] }
    }
  end

  def raw_record_slice
    RawRecordSlice.new(@transformation_definition, params[:page], params[:record]).call
  end

  def app_details_slice
    {
      transformedRecord: {},
      harvestDefinition: @harvest_definition,
      pipeline: @pipeline,
      transformationDefinition: @transformation_definition,
      rejectionReasons: [],
      deletionReasons: []
    }
  end

  def shared_definitions_slice
    {
      ids: @transformation_definition.harvest_definitions.pluck(:id),
      entities: @transformation_definition.harvest_definitions.map(&:to_h).index_by { |definition| definition[:id] }
    }
  end

  def ui_fields_slice
    field_entities = @fields.map { |field| ui_field_entity(field) }
    {
      ids: @fields.pluck(:id),
      entities: field_entities.index_by { |field| field[:id] }
    }
  end

  def ui_field_entity(field)
    {
      id: field[:id],
      saved: true, saving: false,
      deleting: false,
      running: false,
      hasRun: false,
      displayed: false
    }
  end

  def ui_app_details_slice
    {
      fieldNavExpanded: true,
      rawRecordExpanded: true,
      transformedRecordExpanded: true,
      sharedDefinitionsTabActive: false
    }
  end

  def config_slice
    {
      environment: Rails.env
    }
  end
end
