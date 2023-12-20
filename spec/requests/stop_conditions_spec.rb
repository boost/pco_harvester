# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "StopConditions", type: :request do
  let(:user)                  { create(:user) }
  let(:pipeline)              { create(:pipeline, :figshare) }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  let(:harvest_definition)    { create(:harvest_definition, extraction_definition:, pipeline:) }

  before do
    sign_in user
  end

  describe '#create' do
    let(:stop_condition) { build(:stop_condition, extraction_definition:) }

    context 'with valid parameters' do
      it 'creates a new stop condition' do
        expect do
          post pipeline_harvest_definition_extraction_definition_stop_conditions_path(pipeline,
            harvest_definition, extraction_definition), params: {
              stop_condition: stop_condition.attributes
            }
        end.to change(StopCondition, :count).by(1)
      end

      it 'updates the extraction definition last_edited_by' do
        post pipeline_harvest_definition_extraction_definition_stop_conditions_path(pipeline,
          harvest_definition, extraction_definition), params: {
            stop_condition: stop_condition.attributes
          }
        
        expect(extraction_definition.reload.last_edited_by).to eq user
      end

      it 'returns a JSON object representing the new stop condition' do
        post pipeline_harvest_definition_extraction_definition_stop_conditions_path(pipeline,
          harvest_definition, extraction_definition), params: {
            stop_condition: stop_condition.attributes
          }

        stop_condition = response.parsed_body
        
        expect(stop_condition['name']).to eq 'Name'
        expect(stop_condition['content']).to eq "JsonPath.new('$.page').on(response).first == 1"
      end
    end
  end
end
