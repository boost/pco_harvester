# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ContentSources', type: :request do
  let!(:content_source) { create(:content_source, name: 'National Library of New Zealand') }

  describe '#index' do
    it 'displays a list of content sources' do
      get content_sources_path

      expect(response.status).to eq 200
      expect(response.body).to include CGI.escapeHTML(content_source.name)
    end
  end

  describe '#new' do
    it 'renders the form to create a new content source' do
      get new_content_source_path

      expect(response.status).to eq 200
      expect(response.body).to include 'Add New Content Source'
    end
  end

  describe '#show' do
    it 'renders a specific content source' do
      get content_source_path(content_source)

      expect(response.status).to eq 200
      expect(response.body).to include content_source.name
    end
  end

  describe '#edit' do
    it 'renders the form to edit a content source' do
      get edit_content_source_path(content_source)

      expect(response.status).to eq 200
      expect(response.body).to include content_source.name
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      it 'creates a new content source' do
        expect do
          post content_sources_path, params: {
            content_source: attributes_for(:content_source)
          }
        end.to change(ContentSource, :count).by(1)
      end

      it 'redirects to the content_sources_path' do
        post content_sources_path, params: {
          content_source: attributes_for(:content_source)
        }

        expect(response).to redirect_to content_sources_path
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new content source' do
        expect do
          post content_sources_path, params: {
            content_source: { name: nil }
          }
        end.not_to change(ContentSource, :count)
      end

      it 'renders the form again' do
        post content_sources_path, params: {
          content_source: { name: nil }
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'Add New Content Source'
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'updates the content source' do
        patch content_source_path(content_source), params: {
          content_source: { name: 'National Library of New Zealand' }
        }

        content_source.reload

        expect(content_source.name).to eq 'National Library of New Zealand'
      end

      it 'redirects to the content sources page' do
        patch content_source_path(content_source), params: {
          content_source: { name: 'National Library of New Zealand' }
        }

        expect(response).to redirect_to content_sources_path
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the content source' do
        patch content_source_path(content_source), params: {
          content_source: { name: nil }
        }

        content_source.reload

        expect(content_source.name).not_to eq nil
      end

      it 're renders the form' do
        patch content_source_path(content_source), params: {
          content_source: { name: nil }
        }

        expect(response.body).to include content_source.name_in_database
      end
    end
  end
end
