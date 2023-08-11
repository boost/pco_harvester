# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Requests', type: :request do
  let(:user)                       { create(:user) }
  let(:pipeline)                   { create(:pipeline) }
  let(:harvest_definition)         { create(:harvest_definition, extraction_definition:, pipeline:) }
  let!(:extraction_definition)     { create(:extraction_definition, pipeline:) }

  before do
    sign_in user
  end

  describe 'PATCH /update' do
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

  describe 'GET /show' do
    before do
      stub_figshare_harvest_requests(request_one)
    end

    let(:request_one) { create(:request, :figshare_initial_request, extraction_definition:) }
    let(:request_two) { create(:request, :figshare_main_request, extraction_definition:) }

    it 'returns a JSON response of the completed request' do
      get pipeline_harvest_definition_extraction_definition_request_path(pipeline, harvest_definition,
                                                                         extraction_definition, request_one)

      expect(response.status).to eq 200

      json_data = JSON.parse(response.body)

      expected_keys = %w[url format preview http_method created_at updated_at id]

      expected_keys.each do |key|
        expect(json_data).to have_key(key)
      end
    end

    it 'returns a JSON response of the completed request referencing a response' do
      get pipeline_harvest_definition_extraction_definition_request_path(pipeline, harvest_definition,
                                                                         extraction_definition, request_two, previous_request_id: request_one.id)

      expect(response.status).to eq 200

      json_data = JSON.parse(response.body)

      expected_keys = %w[url format preview http_method created_at updated_at id]

      expected_keys.each do |key|
        expect(json_data).to have_key(key)
      end

      expect(JSON.parse(json_data['preview']['body'])['page_nr']).to eq 2
    end
  end
end
