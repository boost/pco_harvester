require 'rails_helper'

RSpec.describe "Parameters", type: :request do
  let(:user)                       { create(:user) }
  let(:pipeline)                   { create(:pipeline) }
  let(:harvest_definition)         { create(:harvest_definition, extraction_definition:, pipeline:) }
  let!(:extraction_definition)     { create(:extraction_definition, pipeline:) }
  let!(:request)                   { create(:request) }

  before do
    sign_in user
  end

  describe '#create' do
    let(:parameter) { build(:parameter, request:, key: 'key', value: 'value') }

    context 'with valid parameters' do
      it 'creates a new parameter' do
        expect do
          post pipeline_harvest_definition_extraction_definition_request_parameters_path(pipeline, harvest_definition, extraction_definition, request), params: {
            parameter: parameter.attributes
          }
        end.to change(Parameter, :count).by(1)
      end

      
      it 'returns a JSON object representing the new parameter' do
        post pipeline_harvest_definition_extraction_definition_request_parameters_path(pipeline, harvest_definition, extraction_definition, request), params: {
          parameter: parameter.attributes
        }

        parameter = JSON.parse(response.body)

        expect(parameter['key']).to eq 'key'
        expect(parameter['value']).to eq 'value'
      end
    end
  end

  describe '#update' do
    let(:parameter) { create(:parameter, request:) }

    context 'with valid parameters' do
      it 'updates the parameter' do
        patch pipeline_harvest_definition_extraction_definition_request_parameter_path(pipeline, harvest_definition, extraction_definition, request, parameter), params: {
          parameter: { key: 'X-Forwarded-For', value: 'ab.cd.ef.gh' }
        }

        parameter.reload

        expect(parameter.key).to eq 'X-Forwarded-For'
        expect(parameter.value).to eq 'ab.cd.ef.gh'
      end

      
      it 'returns a JSON hash of the updated parameter' do
        patch pipeline_harvest_definition_extraction_definition_request_parameter_path(pipeline, harvest_definition, extraction_definition, request, parameter), params: {
          parameter: { key: 'X-Forwarded-For', value: 'ab.cd.ef.gh' }
        }

        expect(JSON.parse(response.body)['key']).to eq 'X-Forwarded-For'
        expect(JSON.parse(response.body)['value']).to eq 'ab.cd.ef.gh'
      end
    end
  end

  describe '#destroy' do
    let!(:parameter) { create(:parameter, request:) }

    it 'deletes the parameter' do
      expect do
        delete pipeline_harvest_definition_extraction_definition_request_parameter_path(pipeline, harvest_definition, extraction_definition, request, parameter)
      end.to change(Parameter, :count).by(-1)
    end

    it 'returns a successful response' do
      delete pipeline_harvest_definition_extraction_definition_request_parameter_path(pipeline, harvest_definition, extraction_definition, request, parameter)

      expect(response.status).to eq 200
    end
  end
end
