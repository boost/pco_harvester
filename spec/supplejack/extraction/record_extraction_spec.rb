# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::RecordExtraction do
  let(:destination) { create(:destination) }
  let(:ed) { create(:extraction_definition, :enrichment, destination:) }
  let(:subject) { described_class.new(ed, 1) }
  
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
  
  describe '#extract' do
    it 'returns an extracted document from a Supplejack API' do
      expect(subject.extract).to be_a(Extraction::Document)
    end
  end
end
