require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  let(:content_partner) { create(:content_partner) }
  let!(:extraction_definition) { create(:extraction_definition, content_partner:) }
  subject! { create(:job) }

  describe '#index' do
    it 'returns a successful response' do
      get jobs_path
      expect(response).to be_successful
    end

    it 'displays the date of the jobs' do
      get jobs_path
      expect(response.body).to include '15 Jan | 13:30 |'
    end
  end

  describe '#show' do
    it 'returns a successful response' do
      get content_partner_extraction_definition_job_path(content_partner, extraction_definition, subject)
      expect(response).to be_successful
    end

    it 'displays the date of the jobs' do
      get content_partner_extraction_definition_job_path(content_partner, extraction_definition, subject)
      expect(response.body).to include '15 Jan | 13:30 |'
    end
  end

  describe '#create' do
    describe 'is successful' do
      it 'redirects to the ED path' do
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner, extraction_definition)
      end

      it 'sets a succesful message' do
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
        follow_redirect!
        expect(response.body).to include 'Job queued successfuly'
      end

      it 'queues a job' do
        expect(ExtractionJob).to receive(:perform_async)
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
      end
    end

    describe 'is not successful' do
      before do
        expect_any_instance_of(Job).to receive(:save).and_return(false)
      end

      it 'redirects to the ED path' do
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
        expect(response).to redirect_to content_partner_extraction_definition_path(content_partner, extraction_definition)
      end

      it 'sets a failure message' do
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
        follow_redirect!
        expect(response.body).to include 'There was an issue launching the job'
      end

      it 'does not queue a job' do
        expect(ExtractionJob).to_not receive(:perform_async)
        post content_partner_extraction_definition_jobs_path(content_partner, extraction_definition)
      end
    end
  end
end
