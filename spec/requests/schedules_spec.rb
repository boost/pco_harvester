require 'rails_helper'

RSpec.describe "Schedules", type: :request do
  let(:pipeline)    { create(:pipeline) }
  let(:user)        { create(:user) }
  let(:destination) { create(:destination) }

  before do
    sign_in(user)
  end

  describe "GET /index" do
    it 'returns a successful response' do
      get pipeline_schedules_path(pipeline)
      
      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /show' do
    let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
    let(:harvest_definitions_to_run) { [harvest_definition.id] }
    let(:schedule)                   { create(:schedule, frequency: 0, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:, name: 'Pipeline Schedule') }

    it 'returns a successful response' do
      get pipeline_schedule_path(pipeline, schedule)

      expect(response).to have_http_status :ok
    end

    it 'displays the name of the schedule' do
      get pipeline_schedule_path(pipeline, schedule)

      expect(response.body).to include schedule.name
    end
  end

  describe "GET /new" do
    it 'returns a successful response' do
      get new_pipeline_schedule_path(pipeline)

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new schedule' do
        expect do
          post pipeline_schedules_path(pipeline), params: {
            schedule: attributes_for(:schedule, pipeline_id: pipeline.id, destination_id: destination.id)
          }
        end.to change(Schedule, :count).by(1)
      end

      it 'redirects to the pipeline' do
        post pipeline_schedules_path(pipeline), params: {
          schedule: attributes_for(:schedule, pipeline_id: pipeline.id, destination_id: destination.id)
        }

        expect(response).to redirect_to pipeline_path(pipeline)
      end

      it 'displays an appropriate message' do
        post pipeline_schedules_path(pipeline), params: {
          schedule: attributes_for(:schedule, pipeline_id: pipeline.id, destination_id: destination.id)
        } 

        follow_redirect!

        expect(response.body).to include 'Schedule created successfully'
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new schedule' do
        expect do
          post pipeline_schedules_path(pipeline), params: {
            schedule: {
              frequency: :daily
            }
          }
        end.to change(Schedule, :count).by(0)
      end

      it 'rerenders the :new template' do
        post pipeline_schedules_path(pipeline), params: {
          schedule: {
            frequency: :daily
          }
        }

        expect(response.body).to include 'New Schedule'
      end

      it 'displays an appropriate message' do
        post pipeline_schedules_path(pipeline), params: {
          schedule: {
            frequency: :daily
          }
        }

        expect(response.body).to include 'There was an issue creating your Schedule'
      end
    end
  end
end
