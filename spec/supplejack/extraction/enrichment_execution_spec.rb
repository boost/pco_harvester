# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::EnrichmentExecution do
  let(:destination) { create(:destination) }
  let(:extraction_definition) { create(:extraction_definition, :enrichment, destination:, throttle: 0) }
  let(:sample_job) { create(:extraction_job, extraction_definition: extraction_definition, kind: 'sample') }
  let(:full_job) { create(:extraction_job, extraction_definition: extraction_definition, kind: 'full') }

  describe '#call' do
    before do
      stub_figshare_enrichment_page_1(destination)  
      stub_figshare_enrichment_page_2(destination)
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

    context 'when the enrichment extraction definition has a throttle' do
      let(:extraction_definition) { create(:extraction_definition, :enrichment, destination:, throttle: 50) }
      let(:job) { create(:extraction_job, extraction_definition: extraction_definition, kind: 'sample') }

      it 'respects the throttle set in the extraction definition' do
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        described_class.new(job).call

        end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        total_time = end_time - start_time

        expect(total_time.ceil).to eq 2
      end
    end
  end
end
