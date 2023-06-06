# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::DocumentExtraction do
  let(:extraction_job) { create(:extraction_job) }
  let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', extraction_jobs: [extraction_job]) }
  let(:subject) { described_class.new(ed, extraction_job.extraction_folder) }

  before do
    stub_request(:get, 'http://google.com/?url_param=url_value').with(
      query: { 'page' => 1, 'per_page' => 50 },
      headers: fake_json_headers
    ).and_return(fake_response('test'))
  end

  describe '#extract' do
    it 'returns an extracted document from a content source' do
      expect(subject.extract).to be_a(Extraction::Document)
    end
  end

  describe '#save' do
    context 'when there is a document to save' do
      it 'saves the document to the filepath' do
        subject.extract
        subject.save

        expect(File.exist?(subject.send(:file_path))).to eq true
      end
    end

    context 'when there is no extraction_folder' do
      it 'returns an extracted document from a content source' do
        doc = described_class.new(ed)
        expect { doc.save }.to raise_error(ArgumentError, 'extraction_folder was not provided in #new')
      end
    end

    context 'when there is not a document to save' do
      it 'returns a helpful error message' do
        expect { subject.save }.to raise_error('#extract must be called before #save AbstractExtraction')
      end
    end
  end

  describe '#extract_and_save' do
    it 'calls both extract and save' do
      expect(subject).to receive(:extract)
      expect(subject).to receive(:save)

      subject.extract_and_save
    end
  end
end
