# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestDefinitions', type: :request do
  let(:content_source)           { create(:content_source, :ngataonga) }
  let(:extraction_definition)     { content_source.extraction_definitions.first }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, content_source:, extraction_job:) }
  let(:destination)               { create(:destination) }
  let(:harvest_definition)        { create(:harvest_definition) }

  describe 'GET /new' do
    it 'has a successful response' do
      get new_content_source_harvest_definition_path(content_source, kind: 'harvest')

      expect(response.status).to eq 200
    end
  end

  describe 'GET /show' do
    it 'has a successful response' do
      get content_source_harvest_definition_path(content_source, harvest_definition)

      expect(response.status).to eq 200
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'creates a new harvest definition' do
        expect do
          post content_source_harvest_definitions_path(content_source), params: {
            harvest_definition: {
              name: 'Staging',
              content_source_id: content_source.id,
              extraction_definition_id: extraction_definition.id,
              transformation_definition_id: transformation_definition.id,
              destination_id: destination.id,
              source_id: 'test'
            }
          }
        end.to change(HarvestDefinition, :count).by(1)
      end

      it 'redirects to the content_source path' do
        post content_source_harvest_definitions_path(content_source), params: {
          harvest_definition: {
            name: 'Staging',
            content_source_id: content_source.id,
            extraction_definition_id: extraction_definition.id,
            transformation_definition_id: transformation_definition.id,
            destination_id: destination.id,
            source_id: 'test'
          }
        }

        expect(response).to redirect_to content_source_path(content_source)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new harvest definition' do
        expect do
          post content_source_harvest_definitions_path(content_source), params: {
            harvest_definition: { name: nil }
          }
        end.not_to change(HarvestDefinition, :count)
      end
    end
  end

  describe 'GET /edit' do
    let(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_source:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    it 'returns a successful response' do
      get edit_content_source_harvest_definition_path(content_source, harvest_definition)

      expect(response.status).to eq 200
    end
  end

  describe 'PATCH /update' do
    let(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_source:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    context 'with valid params' do
      let!(:updated_extraction_definition)     { create(:extraction_definition, base_url: 'http://test.com') }
      let(:updated_field)                      { build(:field, block: 'hello!') }
      let!(:updated_transformation_definition) { create(:transformation_definition, content_source:, extraction_job:, fields: [updated_field]) }

      it 'updates the harvest definition' do
        patch content_source_harvest_definition_path(content_source, harvest_definition), params: {
          harvest_definition: {
            source_id: 'testing'
          }
        }

        harvest_definition.reload

        expect(harvest_definition.source_id).to eq 'testing'
      end

      it 'redirects to the harvest definition path' do
        patch content_source_harvest_definition_path(content_source, harvest_definition), params: {
          harvest_definition: {
            name: 'Production'
          }
        }

        expect(response).to redirect_to content_source_harvest_definition_path(content_source, harvest_definition)
      end

      it 'updates the extraction_definition clone' do
        expect(harvest_definition.extraction_definition.original_extraction_definition).to eq extraction_definition

        patch content_source_harvest_definition_path(content_source, harvest_definition), params: {
          harvest_definition: {
            extraction_definition_id: updated_extraction_definition.id
          }
        }

        harvest_definition.reload
        
        expect(harvest_definition.extraction_definition.original_extraction_definition).to eq updated_extraction_definition

        expect(harvest_definition.extraction_definition.base_url).to eq updated_extraction_definition.base_url
      end

      it 'updates the transformation_definition clone' do
        expect(harvest_definition.transformation_definition.original_transformation_definition).to eq transformation_definition

        patch content_source_harvest_definition_path(content_source, harvest_definition), params: {
          harvest_definition: {
            transformation_definition_id: updated_transformation_definition.id
          }
        }

        harvest_definition.reload
        expect(harvest_definition.transformation_definition.original_transformation_definition).to eq updated_transformation_definition
        expect(harvest_definition.transformation_definition.fields.first.block).to eq updated_transformation_definition.fields.first.block
      end
    end

    context 'with invalid params' do
      it 'does not update the harvest definition' do
        patch content_source_harvest_definition_path(content_source, harvest_definition), params: {
          harvest_definition: {
            source_id: nil
          }
        }

        harvest_definition.reload

        expect(harvest_definition.source_id).not_to eq nil
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_source:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    it 'deletes a harvest definition' do
      expect do
        delete content_source_harvest_definition_path(content_source, harvest_definition)
      end.to change(HarvestDefinition, :count).by(-1)
    end

    it 'redirects to the content source path' do
      delete content_source_harvest_definition_path(content_source, harvest_definition)

      expect(response).to redirect_to content_source_path(content_source)
    end

    it 'does not delete the harvest definition if something has gone wrong' do
      allow_any_instance_of(HarvestDefinition).to receive(:destroy).and_return(false)

      delete content_source_harvest_definition_path(content_source, harvest_definition)

      expect(response).to redirect_to content_source_harvest_definition_path(content_source, harvest_definition)
    end
  end
end
