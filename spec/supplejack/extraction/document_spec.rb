# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::Document do
  subject do
    described_class.new(
      url: 'https://google.com',
      method: 'GET',
      params: { param: :value },
      request_headers: { request_header: :value },
      status: 200,
      response_headers: { response_header: :value },
      body: 'my body'
    )
  end

  describe '#initialize' do
    it 'takes keyword arguments' do
      expect(subject.url).to eq 'https://google.com'
      expect(subject.method).to eq 'GET'
      expect(subject.params).to eq({ param: :value })
      expect(subject.request_headers).to eq({ request_header: :value })
      expect(subject.status).to eq 200
      expect(subject.response_headers).to eq({ response_header: :value })
      expect(subject.body).to eq 'my body'
    end
  end

  describe '#save' do
    let(:file_path) { Rails.root.join('extractions/test_file') }

    before { subject.save(file_path) }
    after { FileUtils.rm(file_path) if File.exist?(file_path) }

    it 'creates a file' do
      expect(File.exist?(file_path)).to be true
    end

    it 'the file is JSON formatted' do
      str = File.read(file_path)
      expect { JSON.parse(str) }.to_not raise_error
    end

    it 'the file contains the hash' do
      str = File.read(file_path)
      expect(JSON.parse(str)).to(
        eq(
          {
            'body' => 'my body',
            'method' => 'GET',
            'params' => { 'param' => 'value' },
            'request_headers' => { 'request_header' => 'value' },
            'response_headers' => { 'response_header' => 'value' },
            'status' => 200,
            'url' => 'https://google.com'
          }
        )
      )
    end
  end

  describe '#load_from_file' do
    let(:file_path) { Rails.root.join('extractions/test_file') }

    before { subject.save(file_path) }
    after { FileUtils.rm(file_path) if File.exist?(file_path) }

    it 'returns an Extraction::Document' do
      expect(described_class.load_from_file(file_path)).to be_a described_class
    end

    it 'the returned document is the same as the previous one' do
      doc = described_class.load_from_file(file_path)

      expect(doc.url).to eq subject.url
      expect(doc.method).to eq subject.method
      expect(doc.params).to eq({ 'param' => 'value' })
      expect(doc.request_headers).to eq({ 'request_header' => 'value' })
      expect(doc.response_headers).to eq({ 'response_header' => 'value' })
      expect(doc.status).to eq subject.status
      expect(doc.body).to eq subject.body
    end
  end

  describe '#to_hash' do
    it 'returns a Hash' do
      expect(subject.to_hash).to be_a Hash
    end

    it 'returns the attributes as hash' do
      expect(subject.to_hash).to(
        eq(
          {
            url: subject.url,
            method: subject.method,
            params: subject.params,
            request_headers: subject.request_headers,
            status: subject.status,
            response_headers: subject.response_headers,
            body: subject.body
          }
        )
      )
    end
  end

  describe '#to_json' do
    it 'returns a String' do
      expect(subject.to_json).to be_a String
    end

    it 'returns the hash as json string' do
      expect(subject.to_json).to eq JSON.generate(subject.to_hash)
    end
  end
end
