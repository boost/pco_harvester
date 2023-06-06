# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transformation Definitions', type: :request do
  let(:content_source) { create(:content_source) }
  let(:extraction_job) { create(:extraction_job) }
  let(:transformation_definition) { create(:transformation_definition, content_source:, extraction_job:) }

  describe '#new' do
    it 'renders the new form' do
      get new_content_source_transformation_definition_path(content_source, kind: 'harvest')

      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    it 'renders the form' do
      get edit_content_source_transformation_definition_path(content_source, transformation_definition)

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:transformation_definition) { build(:transformation_definition, content_source:, extraction_job:) }

      it 'creates a new transformation_definition' do
        expect do
          post content_source_transformation_definitions_path(content_source), params: {
            transformation_definition: transformation_definition.attributes
          }
        end.to change(TransformationDefinition, :count).by(1)
      end

      it 'redirects to the content source path' do
        post content_source_transformation_definitions_path(content_source), params: {
          transformation_definition: transformation_definition.attributes
        }

        expect(response).to redirect_to content_source_path(content_source)
      end
    end

    context 'with invalid parameters' do
      let(:transformation_definition) { build(:transformation_definition) }

      it 'does not create a new transformation_definition' do
        expect do
          post content_source_transformation_definitions_path(content_source), params: {
            transformation_definition: transformation_definition.attributes
          }
        end.not_to change(TransformationDefinition, :count)
      end

      it 'rerenders the new form' do
        post content_source_transformation_definitions_path(content_source), params: {
          transformation_definition: transformation_definition.attributes
        }

        expect(response.status).to eq 200
        expect(response.body).to include 'There was an issue creating your Transformation Definition'
      end
    end
  end

  describe '#show' do
    let(:transformation_definition) { create(:transformation_definition, content_source:, extraction_job:) }

    it 'shows the details for a transformation_definition' do
      get content_source_transformation_definition_path(content_source, transformation_definition)

      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      it 'updates the transformation_definition' do
        patch content_source_transformation_definition_path(content_source, transformation_definition), params: {
          transformation_definition: { name: 'Flickr' }
        }

        transformation_definition.reload

        expect(transformation_definition.name).to eq 'Flickr'
      end

      it 'redirects to the transformation_definitions page' do
        patch content_source_transformation_definition_path(content_source, transformation_definition), params: {
          transformation_definition: { name: 'Flickr' }
        }

        expect(response).to redirect_to(content_source_transformation_definition_path(content_source,
                                                                                       transformation_definition))
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the transformation_definition' do
        patch content_source_transformation_definition_path(content_source, transformation_definition), params: {
          transformation_definition: { record_selector: nil }
        }

        transformation_definition.reload

        expect(transformation_definition.record_selector).not_to eq nil
      end

      it 're renders the form' do
        patch content_source_transformation_definition_path(content_source, transformation_definition), params: {
          transformation_definition: { record_selector: nil }
        }

        expect(response.body).to include transformation_definition.name_in_database
      end
    end
  end

  describe '#destroy' do
    it 'destroys the transformation_definition' do
      delete content_source_transformation_definition_path(content_source, transformation_definition)

      expect(response).to redirect_to(content_source_path(content_source))
      follow_redirect!
      expect(response.body).to include('Transformation Definition deleted successfully')
    end

    it 'displays a message when failing' do
      allow_any_instance_of(TransformationDefinition).to receive(:destroy).and_return false
      delete content_source_transformation_definition_path(content_source, transformation_definition)
      follow_redirect!

      expect(response.body).to include('There was an issue deleting your Transformation Definition')
    end
  end

  describe '#test' do
    let(:content_source) { create(:content_source, :ngataonga) }
    let(:extraction_definition) { content_source.extraction_definitions.first }
    let(:extraction_job) { create(:extraction_job, extraction_definition:) }
    let(:subject) { create(:transformation_definition, content_source:, extraction_job:) }

    before do
      # that's to test the display of results
      stub_ngataonga_harvest_requests(extraction_definition)
      ExtractionWorker.new.perform(extraction_job.id)
    end

    it 'returns a JSON object containing the result of the selected job and the applied record selector' do
      post test_content_source_transformation_definitions_path(content_source), params: {
        transformation_definition: subject.attributes
      }

      expect(response.status).to eq 200

      json_data = JSON.parse(response.body)

      expected_keys = %w[record_id created_at updated_at reference_number thumbnail_url genre authors]

      expected_keys.each do |key|
        expect(json_data).to have_key(key)
      end
    end
  end

  describe 'POST /update_harvest_definitions' do
    let(:field)                     { build(:field, block: 'test') }
    let(:transformation_definition) { create(:transformation_definition, content_source:, fields: [field]) }
    let(:harvest_definition)        { create(:harvest_definition, transformation_definition:) }

    it 'updates associated harvest definitions' do
      expect(harvest_definition.transformation_definition.fields.first.block).to eq 'test'

      transformation_definition.fields.first.update(block: 'testing')
      post update_harvest_definitions_content_source_transformation_definition_path(content_source,
                                                                                     transformation_definition)

      harvest_definition.reload

      expect(harvest_definition.transformation_definition.fields.first.block).to eq 'testing'
    end
  end
end
