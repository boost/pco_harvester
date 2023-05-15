# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::Execution do
  let(:full_job) { create(:extraction_job) }
  let(:sample_job) { create(:extraction_job, kind: 'sample') }
  let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', extraction_jobs: [full_job, sample_job]) }

  before do
    (1...6).each do |page|
      stub_request(:get, 'http://google.com/?url_param=url_value').with(
        query: { 'page' => page, 'per_page' => 50 },
        headers: fake_json_headers
      ).and_return(fake_response('test'))
    end
  end

  describe '#call' do
    context 'when running a full job' do
      let(:subject) { described_class.new(full_job, ed) }

      it 'saves the full response from the content partner to the filesystem' do
        subject.call

        expect(File.exist?(full_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{full_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 5
      end
    end

    context 'when running a sample job' do
      let(:subject) { described_class.new(sample_job, ed) }

      it 'saves the first page from the content partner to the filesystem' do
        subject.call

        expect(File.exist?(sample_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{sample_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 1
      end
    end

    context 'when the extraction definition has a throttle' do
      let(:extraction_job) { create(:extraction_job) }
      let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', throttle: 500, extraction_jobs: [extraction_job]) }
      let(:subject) { described_class.new(extraction_job, ed) }

      it 'it respects the throttle set in the extraction_definition' do
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        subject.call

        end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        total_time = end_time - start_time

        expect(total_time.ceil).to eq 3
      end
    end

    context 'when the job has been cancelled' do
      let(:extraction_job) { create(:extraction_job, status: 'cancelled') }
      let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', throttle: 500, extraction_jobs: [extraction_job]) }
      let(:subject) { described_class.new(extraction_job, ed) }

      it 'it does not extract further pages' do
        subject.call

        expect(File.exist?(extraction_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{extraction_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 2
      end
    end
  end
end
