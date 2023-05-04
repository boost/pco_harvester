require 'rails_helper'

RSpec.describe "Transformations", type: :request do
  let(:content_partner) { create(:content_partner) }
  let(:job)             { create(:job) }
  let(:transformation)  { create(:transformation, content_partner:, job:) }

  describe '#new' do
    it 'renders the new form' do
      get new_content_partner_transformation_path(content_partner)

      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    it 'renders the form' do
      get edit_content_partner_transformation_path(content_partner, transformation)

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
  
  describe '#update' do
    context 'with valid parameters' do
      it 'updates the transformation' do
        patch content_partner_transformation_path(content_partner, transformation), params: {
          transformation: { name: 'Flickr' }
        }

        transformation.reload

        expect(transformation.name).to eq 'Flickr'
      end

      it 'redirects to the transformations page' do
        patch content_partner_transformation_path(content_partner, transformation), params: {
          transformation: { name: 'Flickr' }
        }

        expect(response).to redirect_to(content_partner_transformation_path(content_partner, transformation))
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the transformation' do
        patch content_partner_transformation_path(content_partner, transformation), params: {
          transformation: { name: nil }
        }

        transformation.reload

        expect(transformation.name).not_to eq nil
      end

      it 're renders the form' do
        patch content_partner_transformation_path(content_partner, transformation), params: {
          transformation: { name: nil }
        }

        expect(response.body).to include transformation.name_in_database
      end
    end
  end

  describe '#destroy' do
    it 'destroys the transformation' do
      delete content_partner_transformation_path(content_partner, transformation)

      expect(response).to redirect_to(content_partner_path(content_partner))
      follow_redirect!
      expect(response.body).to include('Transformation deleted successfully')
    end

    it 'displays a message when failing' do
      allow_any_instance_of(Transformation).to receive(:destroy).and_return false
      delete content_partner_transformation_path(content_partner, transformation)
      follow_redirect!

      expect(response.body).to include('There was an issue deleting your Transformation')
    end
  end

  describe '#test' do
    let(:content_partner) { create(:content_partner, :ngataonga) } 
    let(:extraction_definition) { content_partner.extraction_definitions.first }
    let(:job)             { create(:job, extraction_definition:) } 
    let(:subject)         { create(:transformation, content_partner: content_partner, job: job) }

    before do
      # that's to test the display of results
      stub_ngataonga_harvest_requests(extraction_definition)
      ExtractionJob.new.perform(job.id)
    end
    
    it 'returns a JSON object containing the result of the selected job and the applied record selector' do
      
      post test_content_partner_transformations_path(content_partner), params: {
        transformation: subject.attributes
      }

      expect(response.status).to eq 200

      json_data = JSON.parse(response.body)

      expected_keys = %w[record_id created_at updated_at reference_number thumbnail_url genre authors]

      expected_keys.each do |key|
        expect(json_data).to have_key(key)
      end
    end
  end
end
