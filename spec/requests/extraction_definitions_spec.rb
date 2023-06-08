# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExtractionDefinitions', type: :request do
  let(:user)                  { create(:user) }
  let(:content_source)        { create(:content_source) }
  let!(:extraction_definition) { create(:extraction_definition, content_source:) }
  let!(:harvest_definition) { create(:harvest_definition, extraction_definition:) }
  
  before do
    sign_in user
  end

  describe '#show' do
    it 'renders a specific extraction definition' do
      get content_source_extraction_definition_path(extraction_definition.content_source, extraction_definition)
      expect(response.status).to eq 200
      expect(response.body).to include extraction_definition.name
    end

    it 'fetches the associated harvest_definitions' do
      get content_source_extraction_definition_path(extraction_definition.content_source, extraction_definition)
      expect(response.status).to eq 200
      expect(response.body).to include harvest_definition.name
    end
  end

  describe '#new' do
    it 'renders the new form' do
      get new_content_source_extraction_definition_path(content_source, kind: 'harvest')

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new extraction definition' do
        extraction_definition2 = build(:extraction_definition, content_source:)
        expect do
          post content_source_extraction_definitions_path(content_source), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.to change(ExtractionDefinition, :count).by(1)
      end

      it 'redirects to the content_source_path' do
        extraction_definition2 = build(:extraction_definition, content_source:)
        post content_source_extraction_definitions_path(content_source), params: {
          extraction_definition: extraction_definition2.attributes
        }

        expect(response).to redirect_to content_source_path(content_source)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new extraction definition' do
        extraction_definition2 = build(:extraction_definition, format: nil, content_source:)
        expect do
          post content_source_extraction_definitions_path(content_source), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.not_to change(ExtractionDefinition, :count)
      end

      it 'renders the form again' do
        extraction_definition2 = build(:extraction_definition, format: nil, content_source:)
        post content_source_extraction_definitions_path(content_source), params: {
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
        patch content_source_extraction_definition_path(content_source, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        extraction_definition.reload

        expect(extraction_definition.name).to eq 'Flickr'
      end

      it 'redirects to the extraction_definitions page' do
        patch content_source_extraction_definition_path(content_source, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        expect(response).to redirect_to(content_source_extraction_definition_path(content_source,
                                                                                   extraction_definition))
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the content source' do
        patch content_source_extraction_definition_path(content_source, extraction_definition), params: {
          extraction_definition: { format: nil }
        }

        extraction_definition.reload

        expect(extraction_definition.format).not_to eq nil
      end

      it 're renders the form' do
        patch content_source_extraction_definition_path(content_source, extraction_definition), params: {
          extraction_definition: { format: nil }
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
      post test_content_source_extraction_definitions_path(content_source), params: {
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
      stub_figshare_enrichment_page_1(destination)
    end

    it 'returns a document extraction of API records' do
      post test_record_extraction_content_source_extraction_definitions_path(content_source), params: {
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
      stub_figshare_enrichment_page_1(destination)
    end

    it 'returns a document extraction of data for an enrichment' do
      post test_enrichment_extraction_content_source_extraction_definitions_path(content_source), params: {
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
      delete content_source_extraction_definition_path(content_source, extraction_definition)

      expect(response).to redirect_to(content_source_path(content_source))
      follow_redirect!
      expect(response.body).to include('Extraction Definition deleted successfully')
    end

    it 'displays a message when failing' do
      allow_any_instance_of(ExtractionDefinition).to receive(:destroy).and_return false
      delete content_source_extraction_definition_path(content_source, extraction_definition)
      follow_redirect!

      expect(response.body).to include('There was an issue deleting your Extraction Definition')
    end
  end

  describe 'POST /update_harvest_definitions' do
    let!(:extraction_definition) { create(:extraction_definition, content_source:, base_url: 'http://test.co.nz') }
    let(:harvest_definition) { create(:harvest_definition, extraction_definition:) }

    it 'updates associated harvest definitions' do
      expect(harvest_definition.extraction_definition.base_url).to eq 'http://test.co.nz'

      extraction_definition.update(base_url: 'http://testing.co.nz')
      post update_harvest_definitions_content_source_extraction_definition_path(content_source, extraction_definition)

      harvest_definition.reload

      expect(harvest_definition.extraction_definition.base_url).to eq 'http://testing.co.nz'
    end
  end
end
