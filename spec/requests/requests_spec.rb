# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Requests", type: :request do
  let(:user)                       { create(:user) }
  let(:pipeline)                   { create(:pipeline) }
  let(:harvest_definition)         { create(:harvest_definition, extraction_definition:, pipeline:) }
  let!(:extraction_definition)     { create(:extraction_definition, pipeline:) }

  before do
    sign_in user
  end

  describe "PATCH /update" do
    let(:request) { create(:request) }

    context 'with valid parameters' do
      it 'updates the request' do
        patch pipeline_harvest_definition_extraction_definition_request_path(pipeline, harvest_definition, extraction_definition, request), params: {
          request: { http_method: 'POST' }
        }

        request.reload

        expect(request.http_method).to eq 'POST'
      end
      
      it 'renders the request as JSON' do
        patch pipeline_harvest_definition_extraction_definition_request_path(pipeline, harvest_definition, extraction_definition, request), params: {
          request: { http_method: 'POST' }
        }

        request = JSON.parse(response.body)

        expect(request['http_method']).to eq 'POST'
      end
    end
  end

  describe 'GET /test' do
    let(:request) { create(:request, :figshare) }

    it 'returns a JSON response of the completed request' do
      get pipeline_harvest_definition_extraction_definition_request_path(pipeline, harvest_definition, extraction_definition, request)

      body = JSON.parse(response.body)
    end
  end
end
