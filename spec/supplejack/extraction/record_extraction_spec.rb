# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::RecordExtraction do
  let(:destination)           { create(:destination) }
  let(:extraction_definition) { create(:extraction_definition, :enrichment, destination:) }

  describe '#extract' do
    context 'when the enrichment is not scheduled after a harvest' do
      before do
        stub_request(:get, "#{destination.url}/harvester/records")
          .with(
            query: {
              'api_key' => 'testkey',
              'search' => {
                'fragments.source_id' => 'test'
              },
              'search_options' => {
                'page' => 1
              }
            },
            headers: fake_json_headers
          ).to_return(fake_response('test_api_records'))
      end

      let(:subject) { described_class.new(extraction_definition, 1) }

      it 'returns an extracted document from a Supplejack API' do
        expect(subject.extract).to be_a(Extraction::Document)
      end
    end

    context 'when the enrichment is scheduled after a harvest' do
      let(:pipeline)           { create(:pipeline, name: 'NLNZCat') }
      let(:harvest_definition) { create(:harvest_definition, pipeline:, extraction_definition:) }
      let(:harvest_job)        do
        create(:harvest_job, :completed, harvest_definition:, destination:, target_job_id: 'harvest-job-1')
      end
      let(:subject) { described_class.new(extraction_definition, 1, harvest_job) }

      before do
        stub_request(:get, "#{destination.url}/harvester/records")
          .with(
            query: {
              'api_key' => 'testkey',
              'search' => {
                'fragments.job_id' => 'harvest-job-1'
              },
              'search_options' => {
                'page' => 1
              }
            },
            headers: fake_json_headers
          ).to_return(fake_response('test_api_records'))
      end

      it 'returns an extraction document from a particular job from a Supplejack API' do
        expect(subject.extract).to be_a(Extraction::Document)
      end
    end
  end
end
