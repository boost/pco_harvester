# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExtractionDefinitions', type: :request do
  let(:user)                   { create(:user) }
  let(:pipeline)               { create(:pipeline) }
  let!(:extraction_definition) { create(:extraction_definition) }
  let!(:harvest_definition)    { create(:harvest_definition, extraction_definition:, pipeline:) }

  before do
    sign_in user
  end

  describe '#new' do
    it 'renders the new form' do
      get new_pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, kind: 'harvest')

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:extraction_definition2) { build(:extraction_definition, pipeline:) }

      it 'creates a new extraction definition' do
        expect do
          post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.to change(ExtractionDefinition, :count).by(1)
      end

      it 'stores the user who created it' do
        post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
          extraction_definition: extraction_definition2.attributes
        }

        expect(ExtractionDefinition.last.last_edited_by).to eq user
      end

      it 'creates 2 requests for the new extraction definition' do
        expect do
          post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.to change(Request, :count).by(2)

        expect(ExtractionDefinition.last.requests.count).to eq 2
      end

      it 'redirects to the extraction definition' do
        extraction_definition2 = build(:extraction_definition, pipeline:)
        post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
          extraction_definition: extraction_definition2.attributes
        }

        expect(response).to redirect_to pipeline_harvest_definition_extraction_definition_path(pipeline,
                                                                                               harvest_definition, ExtractionDefinition.last)
      end

      it 'associates an extraction definition with a provided harvest definition' do
        harvest_definition = create(:harvest_definition, pipeline:, extraction_definition: nil)
        expect(harvest_definition.extraction_definition).to eq nil

        extraction_definition2 = build(:extraction_definition, pipeline:)
        post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
          extraction_definition: extraction_definition2.attributes.merge(harvest_definition_id: harvest_definition.id)
        }

        harvest_definition.reload

        expect(harvest_definition.extraction_definition).not_to eq nil
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new extraction definition' do
        extraction_definition2 = build(:extraction_definition, format: nil, pipeline:)
        expect do
          post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
            extraction_definition: extraction_definition2.attributes
          }
        end.not_to change(ExtractionDefinition, :count)
      end

      it 'renders the form again' do
        extraction_definition2 = build(:extraction_definition, format: nil, pipeline:)
        post pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
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
        patch pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        extraction_definition.reload

        expect(extraction_definition.name).to eq 'Flickr'
      end

      it 'stores the user who updated it' do
        sign_out(user)
        new_user = create(:user)
        sign_in(new_user)
        patch pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        expect(extraction_definition.reload.last_edited_by).to eq new_user
      end

      it 'redirects to the extraction page' do
        patch pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition), params: {
          extraction_definition: { name: 'Flickr' }
        }

        expect(response).to redirect_to(pipeline_harvest_definition_extraction_definition_path(pipeline,
                                                                                               harvest_definition, extraction_definition))
      end
    end

    context 'with invalid paramaters' do
      it 'does not update the content source' do
        patch pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition), params: {
          extraction_definition: { format: nil }
        }

        extraction_definition.reload

        expect(extraction_definition.format).not_to eq nil
      end

      it 're renders the form' do
        patch pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition), params: {
          extraction_definition: { format: nil }
        }

        expect(response.body).to include extraction_definition.name_in_database
      end
    end
  end

  describe '#test_record_extraction' do
    let(:destination)           { create(:destination) }
    let(:extraction_definition) { create(:extraction_definition, :enrichment, destination:) }

    before do
      stub_figshare_enrichment_page_1(destination)
    end

    it 'returns a document extraction of API records' do
      post test_record_extraction_pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
        extraction_definition: extraction_definition.attributes
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
      post test_enrichment_extraction_pipeline_harvest_definition_extraction_definitions_path(pipeline, harvest_definition), params: {
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

  describe '#clone' do
    let!(:extraction_definition)    { create(:extraction_definition, name: 'one') }
    let!(:request_one)              { create(:request, :figshare_initial_request, extraction_definition:) }
    let!(:request_two)              { create(:request, :figshare_main_request, extraction_definition:) }

    let(:pipeline_two)              { create(:pipeline) }
    let!(:harvest_definition_two)    { create(:harvest_definition, extraction_definition:, pipeline:) }

    context 'when the clone is successful' do
      it 'redirects to the Extraction Definition page' do
        post clone_pipeline_harvest_definition_extraction_definition_path(pipeline_two, harvest_definition_two, extraction_definition), params: {
          extraction_definition: {
            name: 'copy'
          }
        }
  
        expect(response).to redirect_to pipeline_harvest_definition_extraction_definition_path(pipeline_two, harvest_definition_two, ExtractionDefinition.last)
      end

      it 'displays an appropriate message' do
        post clone_pipeline_harvest_definition_extraction_definition_path(pipeline_two, harvest_definition_two, extraction_definition), params: {
          extraction_definition: {
            name: 'copy'
          }
        }

        follow_redirect!
        
        expect(response.body).to include('Extraction Definition cloned successfully')
      end
    end

    context 'when the clone fails' do
      it 'redirects to the pipeline page' do
        post clone_pipeline_harvest_definition_extraction_definition_path(pipeline_two, harvest_definition_two, extraction_definition), params: {
          extraction_definition: {
            name: extraction_definition.name
          }
        }
  
        expect(response).to redirect_to pipeline_path(pipeline_two)
      end

      it 'displays an appropriate message' do
        post clone_pipeline_harvest_definition_extraction_definition_path(pipeline_two, harvest_definition_two, extraction_definition), params: {
          extraction_definition: {
            name: extraction_definition.name
          }
        }

        follow_redirect!
        
        expect(response.body).to include('Extraction Definition clone failed. Please confirm that your Extraction Definition name is unique and then try again.')
      end
    end
  end

  describe '#destroy' do
    let!(:request_one)              { create(:request, :figshare_initial_request, extraction_definition:) }
    let!(:request_two)              { create(:request, :figshare_main_request, extraction_definition:) }

    context 'when the deletion is successful' do
      it 'destroys the Extraction Definition' do
        expect do
          delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)
        end.to change(ExtractionDefinition, :count).by(-1)
      end

      it 'redirects to the pipeline path' do
        delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)
  
        expect(response).to redirect_to(pipeline_path(pipeline))
      end
  
      it 'displays an appropriate message' do
        delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)

        follow_redirect!

        expect(response.body).to include('Extraction Definition deleted successfully')
      end
    end

    context 'when the deletion is unsuccessful' do
      before do
        allow_any_instance_of(ExtractionDefinition).to receive(:destroy).and_return(false)
      end

      it 'does not destroy the Extraction Definition' do
        expect do
          delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)
        end.to change(ExtractionDefinition, :count).by(0)
      end

      it 'redirects to the Extraction Definition path' do
        delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)
  
        expect(response).to redirect_to(pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition))
      end

      it 'displays an appropriate message' do
        delete pipeline_harvest_definition_extraction_definition_path(pipeline, harvest_definition, extraction_definition)

        follow_redirect!

        expect(response.body).to include('There was an issue deleting your Extraction Definition')
      end
    end
  end
end
