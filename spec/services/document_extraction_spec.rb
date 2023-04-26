# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentExtraction do
  let(:job) { create(:job) }
  let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', jobs: [job]) }
  let(:subject) { described_class.new(ed, job.extraction_folder) }

  before do
    init_params = {
      url: 'http://google.com/?url_param=url_value',
      params: { 'page' => 1, 'per_page' => 50  },
      headers: { 'Content-Type' => 'application/json', 'User-Agent' => 'Supplejack Harvester v2.0' }
    }

    stub_request(**init_params) { 'test' }
  end

  describe '#extract' do
    it 'returns an extracted document from a content partner' do
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

    context 'when there is not a document to save' do
      it 'returns a helpful error message' do
        expect{ subject.save }.to raise_error(StandardError, 'A document is required to call save on an instance of DocumentExtraction')
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
