# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestJobs', type: :request do
  subject!                    { create(:harvest_job, harvest_definition:, destination:) }

  let(:destination)           { create(:destination) }
  let(:user)                  { create(:user) }
  let(:extraction_job)        { create(:extraction_job, extraction_definition:, harvest_job: subject) }
  let(:pipeline)              { create(:pipeline, :figshare) }
  let(:harvest_definition)    { pipeline.harvest }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }

  before do
    sign_in user
  end

  describe 'POST /create' do
    let(:harvest_job) { build(:harvest_job, harvest_definition:, destination:, key: SecureRandom.hex) }

    context 'with valid parameters' do
      it 'creates a new HarvestJob' do
        expect do
          post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
            harvest_job: harvest_job.attributes
          }
        end.to change(HarvestJob, :count).by(1)
      end

      it 'schedules a HarvestWorker' do
        expect(HarvestWorker).to receive(:perform_async).once.and_call_original

        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }
      end

      it 'redirects to the pipeline job path' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }

        expect(response).to redirect_to(pipeline_jobs_path(pipeline))
      end

      it 'displays an appropriate flash message' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }

        follow_redirect!

        expect(response.body).to include 'Harvest job queued successfuly'
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new HarvestJob' do
        expect do
          post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
            harvest_job: { title: 'hello' }
          }
        end.not_to change(HarvestJob, :count)
      end

      it 'does not enqueue a HarvestWorker' do
        expect(HarvestWorker).to receive(:perform_async).exactly(0).times.and_call_original

        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello' }
        }
      end

      it 'redirects to the pipeline jobs path' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello' }
        }

        expect(response).to redirect_to(pipeline_jobs_path(pipeline))
      end

      it 'displays an appropriate flash message' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello' }
        }

        follow_redirect!

        expect(response.body).to include 'There was an issue launching the harvest job'
      end
    end
  end

  describe 'POST /cancel' do
    context 'when the cancellation is successful' do
      it 'sets the job status to be cancelled' do
        post cancel_pipeline_harvest_definition_harvest_job_path(pipeline, harvest_definition, subject)

        subject.reload

        expect(subject.status).to eq 'cancelled'
        expect(subject.extraction_job.status).to eq 'cancelled'
      end

      it 'redirects to the correct path' do
        post cancel_pipeline_harvest_definition_harvest_job_path(pipeline, harvest_definition, subject)

        expect(response).to redirect_to pipeline_jobs_path(pipeline)
      end
    end

    context 'when the cancellation is unsuccessful' do
      before do
        allow_any_instance_of(HarvestJob).to receive(:cancelled!).and_return(false)
      end

      it 'does not set the job status to be cancelled' do
        post cancel_pipeline_harvest_definition_harvest_job_path(pipeline, harvest_definition, subject)

        subject.reload

        expect(subject.status).not_to eq 'cancelled'
        expect(subject.extraction_job).not_to eq 'cancelled'
      end

      it 'displays an appropriate flash message' do
        post cancel_pipeline_harvest_definition_harvest_job_path(pipeline, harvest_definition, subject)

        follow_redirect!

        expect(response.body).to include 'There was an issue cancelling the harvest job'
      end
    end
  end
end
