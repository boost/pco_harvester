# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestJobs', type: :request do
  subject!                    { create(:harvest_job, harvest_definition:) }

  let(:user)                  { create(:user) }
  let(:extraction_job)        { create(:extraction_job, extraction_definition:, harvest_job: subject) }
  let(:content_source)       { create(:content_source, :figshare) }
  let(:harvest_definition)    { content_source.harvest_definitions.first }
  let(:extraction_definition) { content_source.extraction_definitions.first }
  
  before do
    sign_in user
  end

  describe 'POST /create' do
    let(:harvest_job) { build(:harvest_job, harvest_definition:) }

    context 'with valid parameters' do
      it 'creates a new HarvestJob' do
        expect do
          post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
            harvest_job: harvest_job.attributes
          }
        end.to change(HarvestJob, :count).by(1)
      end

      it 'schedules a HarvestWorker' do
        expect(HarvestWorker).to receive(:perform_async).exactly(1).times.and_call_original
        
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }
      end

      it 'redirects to the harvest job path' do
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }

        expect(response).to redirect_to(content_source_harvest_definition_harvest_job_path(content_source, harvest_definition, HarvestJob.last))
      end

      it 'displays an appropriate flash message' do
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
          harvest_job: harvest_job.attributes
        }

        follow_redirect!
        
        expect(response.body).to include 'Harvest job queued successfuly'
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new HarvestJob' do
        expect do
          post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
            harvest_job: { title: 'hello' }
          }
        end.to change(HarvestJob, :count).by(0)
      end

      it 'does not enqueue a HarvestWorker' do
        expect(HarvestWorker).to receive(:perform_async).exactly(0).times.and_call_original
        
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
          harvest_job: { title: 'hello' }
        }
      end

      it 'redirects to the harvest definition path' do
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
          harvest_job: { title: 'hello' }
        }

        expect(response).to redirect_to(content_source_harvest_definition_path(content_source, harvest_definition))
      end
      
      it 'displays an appropriate flash message' do
        post content_source_harvest_definition_harvest_jobs_path(content_source, harvest_definition), params: {
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
        post cancel_content_source_harvest_definition_harvest_job_path(content_source, harvest_definition, subject)

        subject.reload

        expect(subject.status).to eq 'cancelled'
        expect(subject.extraction_job.status).to eq 'cancelled'
      end

      it 'redirects to the correct path' do
        post cancel_content_source_harvest_definition_harvest_job_path(content_source, harvest_definition, subject)

        expect(response).to redirect_to content_source_harvest_definition_path(content_source, harvest_definition)
      end
    end

    context 'when the cancellation is unsuccessful' do
      before do
        allow_any_instance_of(HarvestJob).to receive(:cancelled!).and_return(false)
      end

      it 'does not set the job status to be cancelled' do
        post cancel_content_source_harvest_definition_harvest_job_path(content_source, harvest_definition, subject)

        subject.reload

        expect(subject.status).not_to eq 'cancelled'
        expect(subject.extraction_job).not_to eq 'cancelled'
      end

      it 'displays an appropriate flash message' do
        post cancel_content_source_harvest_definition_harvest_job_path(content_source, harvest_definition, subject)

        follow_redirect!

        expect(response.body).to include 'There was an issue cancelling the harvest job'
      end
    end
  end
end
