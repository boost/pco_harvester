require 'rails_helper'

RSpec.describe 'ExtractionDefinitions', type: :request do
  let(:content_partner) { create(:content_partner) }
  let!(:extraction_definition) { create(:extraction_definition, content_partner: content_partner) }

  describe '#show' do
    it 'renders a specific extraction definition' do
      get content_partner_extraction_definition_path(extraction_definition.content_partner, extraction_definition)

      expect(response.status).to eq 200
      expect(response.body).to include extraction_definition.name
    end
  end

  describe '#new' do
    it 'renders the new form' do
      get new_content_partner_extraction_definition_path(content_partner, extraction_definition)

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new extraction definition' do
        expect { 
          post content_partner_extraction_definitions_path(content_partner), params: {
            extraction_definition: {
              name: 'Name',
              content_partner_id: content_partner.id
            }
          }
        }.to change(ExtractionDefinition, :count).by(1)
      end

      it 'redirects to the content_partner_path' do
        post content_partner_extraction_definitions_path(content_partner), params: {
          extraction_definition: {
            name: 'Name',
            content_partner_id: content_partner.id
          }
        }

        expect(response).to redirect_to content_partner_path(content_partner)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new extraction definition' do
        expect { 
          post content_partner_extraction_definitions_path(content_partner), params: {
            extraction_definition: { name: nil }
          }
        }.to change(ExtractionDefinition, :count).by(0)
      end

      it 'renders the form again' do
        post content_partner_extraction_definitions_path(content_partner), params: {
          extraction_definition: { name: nil }
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'New extraction definition'
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

        expect(response).to redirect_to(content_partner_extraction_definition_path(content_partner, extraction_definition))
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
end
