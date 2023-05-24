# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::EnrichmentExecution do
  let(:destination) { create(:destination) }
  let(:extraction_definition) { create(:extraction_definition, :enrichment, destination:, throttle: 0) }
  let(:sample_job) { create(:extraction_job, extraction_definition: extraction_definition, kind: 'sample') }
  let(:full_job) { create(:extraction_job, extraction_definition: extraction_definition, kind: 'full') }

  describe '#call' do
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

      # page 1 api_records stubs
      [23029880, 23029811, 23029790, 23029787, 23029784, 23029733, 23029685, 23029673, 23029661, 23029634, 23072123, 23072120, 23072033, 23071937, 23071886, 23071577, 23071553, 23071328, 23071295, 23071220].each do |article_id|
        stub_request(:get, "https://api.figshare.com/v1/articles/#{article_id}")
          .with(headers: fake_json_headers)
          .to_return(fake_response('figshare_enrichment_1'))
      end
      
    stub_request(:get, "#{destination.url}/harvester/records")
      .with(
        query: {
          'api_key' => 'testkey',
          'search' => {
            'fragments.source_id' => 'test'
          },
          'search_options' => {
            'page' => 2
          }
        },
        headers: fake_json_headers
      ).to_return(fake_response('test_api_records_2'))

    [23071181, 23071178, 23071055, 23070764, 23070638, 23070551, 23070341, 23070317, 23070134, 23069885, 23069813, 23069708, 23069609, 23069582, 23069567, 23069555, 23069426, 23069324, 23069303, 23068361].each do |article_id|
        stub_request(:get, "https://api.figshare.com/v1/articles/#{article_id}")
          .with(headers: fake_json_headers)
          .to_return(fake_response('figshare_enrichment_1'))
      end
    end

    context 'when the job is sample' do
      it 'saves the enrichment for the first 20 records to the filesystem' do
        described_class.new(sample_job).call
        
        expect(File.exist?(sample_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{sample_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 20
      end
    end

    context 'when the job is full' do
      before do
        allow(JsonPath).to receive_message_chain(:new, :on).and_return([2])
      end
      
      it 'saves the enrichment for all the pages to the filesystem' do
        described_class.new(full_job).call
        
        expect(File.exist?(full_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{full_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 40
      end
    end
  end
end
