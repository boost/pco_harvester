# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestDefinitions', type: :request do
  let(:content_partner)           { create(:content_partner, :ngataonga) }
  let(:extraction_definition)     { content_partner.extraction_definitions.first }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, content_partner:, extraction_job:) }
  let(:destination)               { create(:destination) }

  describe 'GET /new' do
    it 'has a successful response' do
      get new_content_partner_harvest_definition_path(content_partner)

      expect(response.status).to eq 200
    end
  end

  describe 'POST /create' do
    context 'with valid attributes' do
      it 'creates a new harvest definition' do
        expect do
          post content_partner_harvest_definitions_path(content_partner), params: {
            harvest_definition: {
              name: 'Staging',
              content_partner_id: content_partner.id,
              extraction_definition_id: extraction_definition.id,
              transformation_definition_id: transformation_definition.id,
              destination_id: destination.id
            }
          }
        end.to change(HarvestDefinition, :count).by(1)
      end

      it 'redirects to the content_partner path' do
        post content_partner_harvest_definitions_path(content_partner), params: {
          harvest_definition: {
            name: 'Staging',
            content_partner_id: content_partner.id,
            extraction_definition_id: extraction_definition.id,
            transformation_definition_id: transformation_definition.id,
            destination_id: destination.id
          }
        }

        expect(response).to redirect_to content_partner_path(content_partner)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new harvest definition' do
        expect do
          post content_partner_harvest_definitions_path(content_partner), params: {
            harvest_definition: { name: nil }
          }
        end.not_to change(HarvestDefinition, :count)
      end
    end
  end

  describe 'GET /edit' do
    let(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_partner:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    it 'returns a successful response' do
      get edit_content_partner_harvest_definition_path(content_partner, harvest_definition)

      expect(response.status).to eq 200
    end
  end

  describe 'PATCH /update' do
    let(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_partner:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    context 'with valid params' do
      it 'updates the harvest definition' do
        patch content_partner_harvest_definition_path(content_partner, harvest_definition), params: {
          harvest_definition: {
            name: 'Production'
          }
        }

        harvest_definition.reload

        expect(harvest_definition.name).to eq 'Production'
      end

      it 'redirects to the harvest definition path' do
        patch content_partner_harvest_definition_path(content_partner, harvest_definition), params: {
          harvest_definition: {
            name: 'Production'
          }
        }

        expect(response).to redirect_to content_partner_harvest_definition_path(content_partner, harvest_definition)
      end
    end

    context 'with invalid params' do
      it 'does not update the harvest definition' do
        patch content_partner_harvest_definition_path(content_partner, harvest_definition), params: {
          harvest_definition: {
            name: nil
          }
        }

        harvest_definition.reload

        expect(harvest_definition.name).not_to eq nil
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:harvest_definition) do
      create(:harvest_definition, name: 'Staging', content_partner:, extraction_definition:, transformation_definition:,
                                  destination:)
    end

    it 'deletes a harvest definition' do
      expect do
        delete content_partner_harvest_definition_path(content_partner, harvest_definition)
      end.to change(HarvestDefinition, :count).by(-1)
    end

    it 'redirects to the content partner path' do
      delete content_partner_harvest_definition_path(content_partner, harvest_definition)

      expect(response).to redirect_to content_partner_path(content_partner)
    end
  end
end
