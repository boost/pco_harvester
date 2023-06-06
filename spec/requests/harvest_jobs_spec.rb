# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HarvestJobs', type: :request do
  subject!                    { create(:harvest_job, harvest_definition:) }

  let(:extraction_job)        { create(:extraction_job, extraction_definition:, harvest_job: subject) }
  let(:content_source)       { create(:content_source, :figshare) }
  let(:harvest_definition)    { content_source.harvest_definitions.first }
  let(:extraction_definition) { content_source.extraction_definitions.first }

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
  end
end
