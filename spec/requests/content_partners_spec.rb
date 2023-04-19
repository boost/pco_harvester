require 'rails_helper'

RSpec.describe "ContentPartners", type: :request do
  let!(:content_partner) { create(:content_partner) }

  describe "#index" do
    it 'displays a list of content partners' do
      get content_partners_path

      expect(response.status).to eq 200
      expect(response.body).to include content_partner.name
    end
  end

  describe '#new' do
    it 'renders the form to create a new content partner' do
      get new_content_partner_path

      expect(response.status).to eq 200
      expect(response.body).to include 'Add New Content Partner'
    end
  end

  describe '#show' do
    it 'renders a specific content partner' do
      get content_partner_path(content_partner)

      expect(response.status).to eq 200
      expect(response.body).to include content_partner.name
    end
  end

  describe '#edit' do
    it 'renders the form to edit a content partner' do
      get edit_content_partner_path(content_partner)

      expect(response.status).to eq 200
      expect(response.body).to include content_partner.name
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new content partner' do
        expect { 
          post content_partners_path, params: {
            content_partner: attributes_for(:content_partner)
          }
        }.to change(ContentPartner, :count).by(1)

      end

      it 'redirects to the content_partners_path' do
        post content_partners_path, params: {
          content_partner: attributes_for(:content_partner)
        }

        expect(response).to redirect_to content_partners_path
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new content partner' do
        expect { 
          post content_partners_path, params: {
            content_partner: { name: nil }
          }
        }.to change(ContentPartner, :count).by(0)
      end

      it 'renders the form again' do
        post content_partners_path, params: {
          content_partner: { name: nil }
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'Add New Content Partner'
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'updates the content partner' do
        patch content_partner_path(content_partner), params: {
          content_partner: { name: 'National Library of New Zealand' }
        }

        content_partner.reload

        expect(content_partner.name).to eq 'National Library of New Zealand'
      end

      it 'redirects to the content partners page' do
        patch content_partner_path(content_partner), params: {
          content_partner: { name: 'National Library of New Zealand' }
        }

        expect(response).to redirect_to content_partners_path
      end
    end

    context 'with invalid paramaters' do 
      it 'does not update the content partner' do
        patch content_partner_path(content_partner), params: {
          content_partner: { name: nil }
        }

        content_partner.reload

        expect(content_partner.name).not_to eq nil
      end

      it 're renders the form' do
        patch content_partner_path(content_partner), params: {
          content_partner: { name: nil }
        }

        expect(response.body).to include content_partner.name_in_database
      end
    end
  end
end
