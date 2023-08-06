# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::DocumentExtraction do
  let(:extraction_job)        { create(:extraction_job) }
  let(:extraction_definition) { create(:extraction_definition, base_url: 'https://api.figshare.com') }
  let(:request)               { create(:request, :figshare, extraction_definition:) }
  subject                     { described_class.new(request, extraction_job.extraction_folder) }

  before do
    stub_figshare_harvest_requests(request)
  end

  describe '#extract' do
    it 'returns an extracted document from the content source' do
      expect(subject.extract).to be_a(Extraction::Document)
    end

    context 'headers' do
      let!(:header_one) { create(:parameter, kind: 'header', name: 'X-Forwarded-For', content: 'ab.cd.ef.gh', request:) }
      let!(:header_two) { create(:parameter, kind: 'header', name: 'Authorization', content: 'Token', request:) }

      it 'appends headers into the Extraction::Request' do
        expect(Extraction::Request).to receive(:new).with(
          url: request.url,
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'Supplejack Harvester v2.0',
            'X-Forwarded-For' => 'ab.cd.ef.gh',
            'Authorization' => 'Token'
          },
          params: {
            'page' => '1',
            'itemsPerPage' => '10',
            'search_for' => 'zealand'
          }
        ).and_call_original

        subject.extract
      end
    end

    context 'Dynamic Parameters' do
      it 'evaluates provided ruby code as parameters' do
        create(:parameter, kind: 'query', name: 'date', content: 'Date.today', request:, dynamic: true)
        create(:parameter, kind: 'header', name: 'X-Forwarded-For', content: '1 + 2', request:, dynamic: true)
        create(:parameter, kind: 'slug', content: '100 / 2', request:, dynamic: true)

        stub_request(:get, "https://api.figshare.com/v1/articles/search/50?date=#{Date.today.to_s}&itemsPerPage=10&page=1&search_for=zealand").
          with(
             headers: {
           'Accept'=>'*/*',
           'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
           'Content-Type'=>'application/json',
           'User-Agent'=>'Supplejack Harvester v2.0',
           'X-Forwarded-For'=>'3'
             }).
           to_return(status: 200, body: "", headers: {})

        expect(Extraction::Request).to receive(:new).with(
          url: request.url,
          headers: {
            'Content-Type'    => 'application/json',
            'User-Agent'      => 'Supplejack Harvester v2.0',
            'X-Forwarded-For' => '3',
          },
          params: {
            'page'         => '1',
            'itemsPerPage' => '10',
            'search_for'   => 'zealand',
            'date'         => Date.today.to_s
          }
        ).and_call_original

        subject.extract
      end

      it 'evaluates provided ruby code as parameters based on a response' do
        previous_extraction = subject.extract

        create(:parameter, kind: 'query', name: 'page', content: 'JSON.parse(response)[\'page_nr\'] + 1' , request:, dynamic: true)
        
        expect(Extraction::Request).to receive(:new).with(
          url: request.url,
          headers: {
            'Content-Type'    => 'application/json',
            'User-Agent'      => 'Supplejack Harvester v2.0',
          },
          params: {
            'page'         => '2',
            'itemsPerPage' => '10',
            'search_for'   => 'zealand',
          }
        ).and_call_original

        described_class.new(request, extraction_job.extraction_folder, previous_extraction.body).extract
      end
    end
  end

  describe '#save' do
    context 'when there is a document to save' do
      it 'saves the document at the filepath' do
        subject.extract
        subject.save
        
        expect(File.exist?(subject.send(:file_path))).to eq true
      end
    end

    context 'when there is no extraction folder' do
      it 'returns an extracted document from a content source' do
        doc = described_class.new(request)
        expect { doc.save }.to raise_error(ArgumentError, 'extraction_folder was not provided in #new')
      end
    end

    
    context 'when there is no document to save' do
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
