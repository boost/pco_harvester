# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RawRecords', type: :request do
  let(:user) { create(:user) }
  let(:pipeline) { create(:pipeline, :figshare) }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, pipeline:, extraction_job:) }
  let(:request)                 { create(:request, :figshare_initial_request, extraction_definition:) }

  before do
    sign_in user

    stub_figshare_harvest_requests(request)
    ExtractionWorker.new.perform(extraction_job.id)
  end

  describe '#index' do
    it 'is successful' do
      get transformation_definition_raw_records_path(transformation_definition)
      expect(response).to be_successful
    end

    it 'has the right shape' do
      get transformation_definition_raw_records_path(transformation_definition)
      expect(response.parsed_body.keys).to eq(
        %w[
          page
          record
          totalPages
          totalRecords
          format
          body
        ]
      )
    end

    it 'defaults to page and record 1' do
      get transformation_definition_raw_records_path(transformation_definition)
      expect(response.parsed_body['page']).to eq 1
      expect(response.parsed_body['record']).to eq 1
    end
  end
end
