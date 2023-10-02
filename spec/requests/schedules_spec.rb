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

      it 'redirects to the new schedule' do
        post pipeline_schedules_path(pipeline), params: {
          schedule: attributes_for(:schedule, pipeline_id: pipeline.id, destination_id: destination.id)
        }

        expect(response).to redirect_to pipeline_schedules_path(pipeline, Schedule.last)
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

  describe 'GET /edit' do
    let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
    let(:harvest_definitions_to_run) { [harvest_definition.id] }
    let(:schedule)                   { create(:schedule, frequency: 0, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:, name: 'Pipeline Schedule') }

    it 'returns a successful response' do
      get edit_pipeline_schedule_path(pipeline, schedule)

      expect(response).to have_http_status :ok
    end
  end

  describe 'PATCH /update' do
    let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
    let(:harvest_definitions_to_run) { [harvest_definition.id] }
    let(:schedule)                   { create(:schedule, frequency: 0, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:, name: 'Pipeline Schedule') }

    context 'with valid parameters' do
      it 'updates the schedule' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: 'Changed Name',
            harvest_definitions_to_run:
          }
        }
  
        schedule.reload
  
        expect(schedule.name).to eq 'Changed Name'
      end
  
      it 'redirects to the updated schedule' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: 'Changed Name',
            harvest_definitions_to_run:
          }
        }
  
        expect(response).to redirect_to pipeline_schedule_path(pipeline, schedule)
      end
      
      it 'displays an appropriate message' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: 'Changed Name',
            harvest_definitions_to_run:
          }
        }

        follow_redirect!

        expect(response.body).to include 'Schedule updated successfully'
      end
    end

    context 'with invalid parameters' do
      it 'does not update the schedule' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: ''
          }
        }
  
        schedule.reload
  
        expect(schedule.name).not_to eq ''
      end

      it 're-renders the edit form' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: ''
          }
        }

        expect(response.body).to include 'Edit Schedule'
      end

      it 'displays an appropriate message' do
        patch pipeline_schedule_path(pipeline, schedule), params: {
          schedule: {
            name: ''
          }
        } 

        expect(response.body).to include 'There was an issue updating your Schedule'
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
    let(:harvest_definitions_to_run) { [harvest_definition.id] }
    let!(:schedule)                   { create(:schedule, frequency: 0, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:, name: 'Pipeline Schedule') }

    context 'when the destroy is successful' do
      it 'deletes the schedule' do
        expect do
          delete pipeline_schedule_path(pipeline, schedule)
        end.to change(Schedule, :count).by(-1)
      end

      it 'redirects to the pipeline schedules page' do
        delete pipeline_schedule_path(pipeline, schedule)

        expect(response).to redirect_to pipeline_schedules_path(pipeline)
      end

      it 'displays an appropriate message' do
        delete pipeline_schedule_path(pipeline, schedule)

        follow_redirect!

        expect(response.body).to include 'Schedule deleted successfully'
      end
    end

    context 'when the destroy is not successful' do
      before do
        allow_any_instance_of(Schedule).to receive(:destroy).and_return(false)
      end

      it 'does not delete the schedule' do
        expect do
          delete pipeline_schedule_path(pipeline, schedule)
        end.to change(Schedule, :count).by(0)
      end

      it 'redirects to the pipeline schedule page' do
        delete pipeline_schedule_path(pipeline, schedule)

        expect(response).to redirect_to pipeline_schedule_path(pipeline, schedule)
      end

      it 'displays an appropriate message' do
        delete pipeline_schedule_path(pipeline, schedule)

        follow_redirect!

        expect(response.body).to include 'There was an issue deleting your Schedule'
      end
    end
  end
end
