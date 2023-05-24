# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExtractionDefinitions', type: :request do
  let(:content_partner)        { create(:content_partner) }
  let!(:extraction_definition) { create(:extraction_definition, content_partner:) }
  let!(:harvest_definition) { create(:harvest_definition, extraction_definition:) }

  describe '#show' do
    it 'renders a specific extraction definition' do
      get content_partner_extraction_definition_path(extraction_definition.content_partner, extraction_definition)
      expect(response.status).to eq 200
      expect(response.body).to include extraction_definition.name
    end

    it 'fetches the associated harvest_definitions' do
      get content_partner_extraction_definition_path(extraction_definition.content_partner, extraction_definition)
      expect(response.status).to eq 200
      expect(response.body).to include harvest_definition.name
    end
  end

  describe '#new' do
    it 'renders the new form' do
      get new_content_partner_extraction_definition_path(content_partner, kind: 'harvest')

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new extraction definition' do
        extraction_definition2 = build(:extraction_definition, content_partner:)
        expect do
          post content_partner_extraction_definitions_path(content_partner), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.to change(ExtractionDefinition, :count).by(1)
      end

      it 'redirects to the content_partner_path' do
        extraction_definition2 = build(:extraction_definition, content_partner:)
        post content_partner_extraction_definitions_path(content_partner), params: {
          extraction_definition: extraction_definition2.attributes
        }

        expect(response).to redirect_to content_partner_path(content_partner)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new extraction definition' do
        extraction_definition2 = build(:extraction_definition, name: nil, content_partner:)
        expect do
          post content_partner_extraction_definitions_path(content_partner), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.not_to change(ExtractionDefinition, :count)
      end

      it 'renders the form again' do
        extraction_definition2 = build(:extraction_definition, name: nil, content_partner:)
        post content_partner_extraction_definitions_path(content_partner), params: {
          extraction_definition: extraction_definition2.attributes
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'There was an issue creating your Extraction Definition'
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'updates the extraction definition' do
        patch content_partner_extraction_definition_path(content_partner, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        extraction_definition.reload

        expect(extraction_definition.name).to eq 'Flickr'
      end

      it 'redirects to the extraction_definitions page' do
        patch content_partner_extraction_definition_path(content_partner, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        expect(response).to redirect_to(content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition))
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the content partner' do
        patch content_partner_extraction_definition_path(content_partner, extraction_definition), params: {
          extraction_definition: { name: nil }
        }

        extraction_definition.reload

        expect(extraction_definition.name).not_to eq nil
      end

      it 're renders the form' do
        patch content_partner_extraction_definition_path(content_partner, extraction_definition), params: {
          extraction_definition: { name: nil }
        }

        expect(response.body).to include extraction_definition.name_in_database
      end
    end
  end

  describe '#test' do
    let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value') }

    before do
      stub_request(:get, 'http://google.com/?url_param=url_value').with(
        query: { 'page' => 1, 'per_page' => 50 },
        headers: fake_json_headers
      ).and_return(fake_response('test'))
    end

    it 'returns a document extraction as JSON' do
      post test_content_partner_extraction_definitions_path(content_partner), params: {
        extraction_definition: ed.attributes
      }

      expect(response.status).to eq 200

      json_data = JSON.parse(response.body)

      expected_keys = %w[url method params request_headers status response_headers body]

      expected_keys.each do |key|
        expect(json_data).to have_key(key)
      end
    end
  end

  describe '#test_record_extraction' do
    let(:destination) { create(:destination) }
    let(:ed) { create(:extraction_definition, :enrichment, destination:) }

    before do
      stub_request(:get, "#{destination.url}/harvester/records")
        .with(
          query: {
            'api_key' => 'testkey',
            'search' => {
              'fragments.source_id' => 'test'
            },
            'search_options' => {
              'page' => 1
            }
          },
          headers: fake_json_headers
        ).to_return(fake_response('test_api_records'))
    end

    it 'returns a document extraction of API records' do
      post test_record_extraction_content_partner_extraction_definitions_path(content_partner), params: {
        extraction_definition: ed.attributes
      }

      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)['body']
      records = JSON.parse(json_response)['records']

      records.each do |record|
        expect(record).to have_key('dc_identifier')
        expect(record).to have_key('internal_identifier')
      end
    end
  end

  describe '#test_enrichment_extraction' do
    let(:destination) { create(:destination) }
    let(:ed) { create(:extraction_definition, :enrichment, destination:) }

    before do
      stub_request(:get, "#{destination.url}/harvester/records")
        .with(
          query: {
            'api_key' => 'testkey',
            'search' => {
              'fragments.source_id' => 'test'
            },
            'search_options' => {
              'page' => 1
            }
          },
          headers: fake_json_headers
        ).to_return(fake_response('test_api_records'))

      stub_request(:get, 'https://api.figshare.com/v1/articles/123')
        .with(headers: fake_json_headers)
        .to_return(fake_response('test_figshare_enrichment'))
    end

    it 'returns a document extraction of data for an enrichment' do
      post test_enrichment_extraction_content_partner_extraction_definitions_path(content_partner), params: {
        extraction_definition: ed.attributes
      }

      expect(response.status).to eq 200

      json_response = JSON.parse(response.body)['body']
      records = JSON.parse(json_response)['items']

      records.each do |record|
        expect(record).to have_key('article_id')
      end
    end
  end

  describe '#destroy' do
    it 'destroys the extraction definition' do
      delete content_partner_extraction_definition_path(content_partner, extraction_definition)

      expect(response).to redirect_to(content_partner_path(content_partner))
      follow_redirect!
      expect(response.body).to include('Extraction Definition deleted successfully')
    end

    it 'displays a message when failing' do
      allow_any_instance_of(ExtractionDefinition).to receive(:destroy).and_return false
      delete content_partner_extraction_definition_path(content_partner, extraction_definition)
      follow_redirect!

      expect(response.body).to include('There was an issue deleting your Extraction Definition')
    end
  end
end
