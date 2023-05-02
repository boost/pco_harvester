require 'rails_helper'

RSpec.describe "Transformations", type: :request do
  let(:content_partner) { create(:content_partner) }
  let(:job)             { create(:job) }

  describe '#new' do
    it 'renders the new form' do
      get new_content_partner_transformation_path(content_partner)

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:transformation) { build(:transformation, content_partner:, job:) }

      it 'creates a new transformation' do
        expect do
          post content_partner_transformations_path(content_partner), params: {
            transformation: transformation.attributes
          }
        end.to change(Transformation, :count).by(1)
      end

      it 'redirects to the content partner path' do
          post content_partner_transformations_path(content_partner), params: {
            transformation: transformation.attributes
          }

        expect(response).to redirect_to content_partner_path(content_partner)
      end
    end

    context 'with invalid parameters' do
      let(:transformation) { build(:transformation) }

      it 'does not create a new transformation' do
        expect do
          post content_partner_transformations_path(content_partner), params: {
            transformation: transformation.attributes
          }
        end.to change(Transformation, :count).by(0)
      end

      it 'rerenders the new form' do
        post content_partner_transformations_path(content_partner), params: {
          transformation: transformation.attributes
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'New Transformation'
      end
    end
  end

  describe '#show' do
    let(:transformation) { create(:transformation, content_partner:, job:) }

    it 'shows the details for a transformation' do
      get content_partner_transformation_path(content_partner, transformation)

      expect(response.status).to eq 200
    end
  end
end
