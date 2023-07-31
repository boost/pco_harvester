require 'rails_helper'

RSpec.describe "Parameters", type: :request do
  let(:user)                       { create(:user) }
  let(:pipeline)                   { create(:pipeline) }
  let(:harvest_definition)         { create(:harvest_definition, extraction_definition:, pipeline:) }
  let!(:extraction_definition)     { create(:extraction_definition, pipeline:) }
  let!(:request)                   { create(:request, extraction_definition:) }

  before do
    sign_in user
  end

  describe '#create' do
    let(:parameter) { build(:parameter) }

    context 'with valid parameters' do
      it 'creates a new parameter' do
        expect do
          post pipeline_harvest_definition_extraction_definition_requests_parameters_path(pipeline, harvest_definition, extraction_definition, request), params: {
            parameter: parameter.attributes
          }
        end.to change(Parameter, :count).by(1)
      end

      
      it 'returns a JSON object representing the new parameter' do
        post pipeline_harvest_definition_extraction_definition_requests_parameters_path(pipeline, harvest_definition, extraction_definition, request), params: {
          parameter: parameter.attributes
        }

        parameter = JSON.parse(response.body)

        expect(parameter['key']).to eq 'from'
        expect(parameter['value']).to eq 'date'
      end
    end
  end
end
