# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestJobs', type: :request do
  subject!                             { create(:harvest_job, harvest_definition:, destination:) }

  let(:destination)                    { create(:destination) }
  let(:user)                           { create(:user) }
  let(:extraction_job)                 { create(:extraction_job, extraction_definition:, harvest_job: subject) }
  let(:pipeline)                       { create(:pipeline, :figshare) }
  let(:harvest_definition)             { pipeline.harvest }
  let(:extraction_definition)          { pipeline.harvest.extraction_definition }
  let!(:enrichment_definition)         { create(:harvest_definition, :enrichment, pipeline:) }
  let!(:enrichment_definition_two)     { create(:harvest_definition, :enrichment, pipeline:) }

  before do
    sign_in user
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      context 'when scheduling a Harvest' do
        let(:harvest_job) { build(:harvest_job, harvest_definition:, destination:, key: SecureRandom.hex, harvest_definitions_to_run: [harvest_definition.id]) }

        it 'creates a new HarvestJob' do
          expect do
            post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
              harvest_job: harvest_job.attributes
            }
          end.to change(HarvestJob, :count).by(1)

          expect(HarvestJob.last.harvest_definition.harvest?).to eq true
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

          expect(response.body).to include 'Job queued successfully'
        end
      end

      context 'when scheduling enrichments' do
        let(:harvest_job) { build(:harvest_job, harvest_definition: enrichment_definition, destination:, key: SecureRandom.hex, harvest_definitions_to_run: [enrichment_definition.id]) }

        it 'creates a new Enrichment' do
          expect do
            post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
              harvest_job: harvest_job.attributes
            }
          end.to change(HarvestJob, :count).by(1)

          expect(HarvestJob.last.harvest_definition.enrichment?).to eq true
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

          expect(response.body).to include 'Job queued successfully'
        end

        it 'does not schedule enrichments that were not selected to be run' do
          post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
            harvest_job: harvest_job.attributes
          }

          expect(HarvestJob.all.map(&:harvest_definition)).not_to(include enrichment_definition_two)          
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new HarvestJob' do
        expect do
          post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
            harvest_job: { title: 'hello', harvest_definitions_to_run: [harvest_definition.id] }
          }
        end.not_to change(HarvestJob, :count)
      end

      it 'does not enqueue a HarvestWorker' do
        expect(HarvestWorker).to receive(:perform_async).exactly(0).times.and_call_original

        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello', harvest_definitions_to_run: [harvest_definition.id] }
        }
      end

      it 'redirects to the pipeline jobs path' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello', harvest_definitions_to_run: [harvest_definition.id] }
        }

        expect(response).to redirect_to(pipeline_jobs_path(pipeline))
      end

      it 'displays an appropriate flash message' do
        post pipeline_harvest_definition_harvest_jobs_path(pipeline, harvest_definition), params: {
          harvest_job: { title: 'hello', harvest_definitions_to_run: [harvest_definition.id] }
        }

        follow_redirect!

        expect(response.body).to include 'There was an issue queueing your job'
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
