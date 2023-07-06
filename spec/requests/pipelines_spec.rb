require 'rails_helper'

RSpec.describe "Pipelines", type: :request do
  let(:user) { create(:user) }
  let!(:pipeline) { create(:pipeline, name: 'DigitalNZ Production') }

  before do
    sign_in(user)
  end

  describe "GET /index" do
    it 'displays a list of pipelines' do
      get pipelines_path

      expect(response.status).to eq 200
      expect(response.body).to include CGI.escapeHTML(pipeline.name)
    end
  end

  describe "POST /create" do
    context 'with valid attributes' do
      it 'creates a new pipeline' do
        expect do
          post pipelines_path, params: {
            pipeline: attributes_for(:pipeline)
          }
        end.to change(Pipeline, :count).by(1)
      end

      it 'redirects to the created pipeline' do
        post pipelines_path, params: {
          pipeline: attributes_for(:pipeline)
        }

        expect(request).to redirect_to(pipeline_path(Pipeline.last))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new pipeline' do
        expect do
          post pipelines_path, params: {
            pipeline: {
              name: nil,
              description: nil
            }
          }
        end.to change(Pipeline, :count).by(0)
      end

      it 'renders the :index template' do
        post pipelines_path, params: {
          pipeline: {
            name: nil,
            description: nil
          }
        }

        expect(response.body).to include 'Pipelines'
        expect(response.body).to include 'There was an issue creating your Pipeline'
      end
    end
  end

  describe '#show' do
    it 'renders a specific pipeline' do
      get pipeline_path(pipeline)

      expect(response.status).to eq 200
      expect(response.body).to include pipeline.name
    end
  end
end
