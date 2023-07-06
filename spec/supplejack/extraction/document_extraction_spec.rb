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

    context 'intial_params' do
      before do
       stub_request(:get, "http://google.com/?from=#{(Date.today - 2.days).strftime("%Y-%m-%d")}&metadataPrefix=marc21&page=1&per_page=50&set=INNZ&url_param=url_value").
         with(
           headers: {
       	 'Accept'=>'*/*',
       	 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	 'Content-Type'=>'application/json',
       	 'User-Agent'=>'Supplejack Harvester v2.0'
           }).
         to_return(status: 200, body: "", headers: {})

        stub_request(:get, "http://google.com/?page=2&per_page=50&url_param=url_value").
           with(
             headers: {
         	 'Accept'=>'*/*',
         	 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         	 'Content-Type'=>'application/json',
         	 'User-Agent'=>'Supplejack Harvester v2.0'
             }).
           to_return(status: 200, body: "", headers: {})
      end

      let(:ed) { create(:extraction_definition, page: 1, base_url: 'http://google.com/?url_param=url_value', extraction_jobs: [extraction_job], initial_params: '"metadataPrefix=marc21&set=INNZ&from=#{(Date.today - 2.days).strftime("%Y-%m-%d").to_s}"') }

      it 'appends initial_params to the first request' do
        expect(Extraction::Request).to receive(:new).with(
          url: ed.base_url,
          headers: { 
            "Content-Type" =>"application/json",
            "User-Agent"   => "Supplejack Harvester v2.0"
          },
          params: {
            "metadataPrefix" => "marc21",
            "page" => 1,
            "per_page" => 50,
            "from" => (Date.today - 2.days).strftime("%Y-%m-%d"),
            "set" => "INNZ"
          }
        ).and_call_original

        subject.extract
      end

      it 'does not append the initial params to subsequent requests' do
        expect(Extraction::Request).to receive(:new).with(
          url: ed.base_url,
          headers: { 
            "Content-Type" =>"application/json",
            "User-Agent"   => "Supplejack Harvester v2.0"
          },
          params: {
            "page" => 2,
            "per_page" => 50,
          }
        ).and_call_original

        ed.update(page: 2)

        subject.extract
      end
    end

    context 'headers' do
      let(:header1) { create(:header, name: 'X-Forwarded-For', value: 'ab.cd.ef.gh') }
      let(:header2) { create(:header, name: 'Authorization', value: 'Token') }
      let(:ed) { create(:extraction_definition, page: 1, base_url: 'http://google.com/?url_param=url_value', extraction_jobs: [extraction_job], headers: [header1, header2]) }

      it 'appends headers from the ExtractionDefinition into the request' do
        expect(Extraction::Request).to receive(:new).with(
          url: ed.base_url,
          headers: { 
            "Content-Type"    => "application/json",
            "User-Agent"      => "Supplejack Harvester v2.0",
            "X-Forwarded-For" => 'ab.cd.ef.gh',
            "Authorization"   => 'Token'
          },
          params: {
            "page" => 1,
            "per_page" => 50,
          }
        ).and_call_original

        subject.extract
      end
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
