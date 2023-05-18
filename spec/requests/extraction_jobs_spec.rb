# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExtractionJobs', type: :request do
  subject! { create(:extraction_job, extraction_definition:) }

  let(:content_partner) { create(:content_partner, :ngataonga) }
  let(:extraction_definition) { content_partner.extraction_definitions.first }

  describe '#index' do
    it 'returns a successful response' do
      get extraction_jobs_path
      expect(response).to be_successful
    end

    it 'displays the date of the jobs' do
      get extraction_jobs_path
      expect(response.body).to include 'Sunday 16 January 2000 |  2:30 AM'
    end

    describe 'filters' do
      before do
        ExtractionJob::STATUSES.excluding(subject.status).each do |status|
          create(:extraction_job, status:)
        end
      end

      it 'displays all kind of jobs by default' do
        get extraction_jobs_path

        expect(response.body).to include 'Waiting in queue...'
        expect(response.body).to include 'Running full job...'
        expect(response.body).to include 'An error occured'
        expect(response.body).to include 'Cancelled'
        expect(response.body).to include 'Completed'
      end

      it 'can filter on queued jobs',
         pending: 'waiting on system tests, Cancelled is present on the page because of the filters' do
        get extraction_jobs_path(status: 'queued')

        expect(response.body).to include 'Waiting in queue...'
        expect(response.body).not_to include 'Running full job...'
        expect(response.body).not_to include 'An error occured'
        expect(response.body).not_to include 'Cancelled'
        expect(response.body).not_to include 'Completed'
      end
    end
  end

  describe '#show' do
    before do
      # that's to test the display of results
      stub_ngataonga_harvest_requests(extraction_definition)
      ExtractionWorker.new.perform(subject.id)
    end

    it 'returns a successful response' do
      get content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition, subject)
      expect(response).to be_successful
    end

    it 'displays the updated_at of the jobs' do
      get content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition, subject)
      subject.reload
      expect(response.body).to include subject.updated_at.to_fs(:verbose)
    end
  end

  describe '#create' do
    describe 'is successful' do
      it 'redirects to the ED path' do
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition,
                                                                        kind: 'full')
        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition)
      end

      it 'sets a succesful message' do
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition,
                                                                        kind: 'full')
        follow_redirect!
        expect(response.body).to include 'Job queued successfuly'
      end

      it 'queues a job' do
        expect(ExtractionWorker).to receive(:perform_async)
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition,
                                                                        kind: 'full')
      end
    end

    describe 'is not successful' do
      before do
        expect_any_instance_of(ExtractionJob).to receive(:save).and_return(false)
      end

      it 'redirects to the ED path' do
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition)
        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition)
      end

      it 'sets a failure message' do
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition)
        follow_redirect!
        expect(response.body).to include 'There was an issue launching the job'
      end

      it 'does not queue a job' do
        expect(ExtractionWorker).not_to receive(:perform_async)
        post content_partner_extraction_definition_extraction_jobs_path(content_partner, extraction_definition)
      end
    end
  end

  describe '#destroy' do
    context 'when the destroy is successful' do
      it 'deletes the job' do
        expect do
          delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                           subject)
        end.to change(ExtractionJob, :count).by(-1)
      end

      it 'redirects to the correct path' do
        delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                         subject)

        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition)
      end

      it 'displays an appropriate flash message' do
        delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                         subject)

        follow_redirect!

        expect(response.body).to include 'Results deleted successfully'
      end
    end

    context 'when the destroy is not successful' do
      before do
        allow_any_instance_of(ExtractionJob).to receive(:destroy).and_return(false)
      end

      it 'does not delete the job' do
        expect do
          delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                           subject)
        end.not_to change(ExtractionJob, :count)
      end

      it 'redirects to the correct path' do
        delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                         subject)

        expect(response).to redirect_to content_partner_extraction_definition_extraction_job_path(content_partner,
                                                                                                  extraction_definition, subject)
      end

      it 'displays an appropriate flash message' do
        delete content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                         subject)

        follow_redirect!

        expect(response.body).to include 'There was an issue deleting the results'
      end
    end
  end

  describe '#cancel' do
    context 'when the cancellation is successful' do
      it 'sets the job status to be cancelled' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        subject.reload
        expect(subject.status).to eq 'cancelled'
      end

      it 'redirects to the correct path' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition)
      end

      it 'displays an appropriate flash message' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        follow_redirect!

        expect(response.body).to include 'Job cancelled successfully'
      end
    end

    context 'when the cancellation is unsuccessful' do
      before do
        allow_any_instance_of(ExtractionJob).to receive(:cancelled!).and_return(false)
      end

      it 'does not set the job status to be cancelled' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        subject.reload
        expect(subject.status).not_to eq 'cancelled'
      end

      it 'redirects to the correct path' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner,
                                                                                   extraction_definition)
      end

      it 'displays an appropriate flash message' do
        post cancel_content_partner_extraction_definition_extraction_job_path(content_partner, extraction_definition,
                                                                              subject)

        follow_redirect!

        expect(response.body).to include 'There was an issue cancelling the job'
      end
    end
  end

  describe '#finished?' do
    let(:finished_ej) { create(:extraction_job, status: 'completed') }
    let(:unfinished_ej) { create(:extraction_job, status: 'running') }

    it 'returns true if the job has finished' do
      expect(finished_ej.finished?).to eq true
    end

    it 'returns false if the job has not finished' do
      expect(unfinished_ej.finished?).to eq false
    end
  end
end
