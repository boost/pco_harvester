# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Destinations", type: :request do
  let(:destination) { create(:destination) }

  describe "GET /index" do
    it 'displays a list of destinations' do
      get destinations_path

      expect(response.status).to eq 200
    end
  end

  describe "GET /show" do
    it 'displays a particular destination' do
      get destination_path(destination)

      expect(response.status).to eq 200
    end
  end

  describe "POST /create" do
    context 'with valid attributes' do
      it 'creates a new destination' do
        expect do
          post destinations_path, params: {
            destination: attributes_for(:destination)
          }
        end.to change(Destination, :count).by(1)
      end

      it 'redirects to the destinations page' do
        post destinations_path, params: {
          destination: attributes_for(:destination)
        }

        expect(response).to redirect_to destinations_path
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new destination' do
        expect do
          post destinations_path, params: {
            destination: { name: 'hello' }
          }
        end.to change(Destination, :count).by(0)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid attributes' do
      it 'updates an existing destination' do
        patch destination_path(destination), params: {
          destination: { name: 'Updated Destination' }
        }

        destination.reload

        expect(destination.name).to eq 'Updated Destination'
      end

      it 'redirects to the destinations page' do
        patch destination_path(destination), params: {
          destination: { name: 'Updated Destination' }
        }

        expect(response).to redirect_to destinations_path
      end
    end

    context 'with invalid attributes' do
      it 'does not update an existing destination' do
        patch destination_path(destination), params: {
          destination: { name: nil }
        }

        destination.reload

        expect(destination.name).not_to eq nil
      end
    end
  end
end
