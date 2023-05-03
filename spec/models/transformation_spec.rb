require 'rails_helper'

RSpec.describe Transformation, type: :model do
  let(:content_partner) { create(:content_partner, :ngataonga) } 
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:job)             { create(:job, extraction_definition:) } 
  let(:subject)         { create(:transformation, content_partner: content_partner, job: job) }

  let!(:attribute_one)   { create(:attribute, name: 'title', block: "JsonPath.new('title').on(record).first", transformation: subject) }
  let!(:attribute_two)   { create(:attribute, name: 'source', block: "JsonPath.new('source').on(record).first", transformation: subject) }
  let!(:attribute_three) { create(:attribute, name: 'dc_identifier', block: "JsonPath.new('reference_number').on(record).first", transformation: subject) }
  let!(:attribute_four) { create(:attribute, name: 'landing_url', block: '"http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=#{record[\'record_id\']}"', transformation: subject) }
  
  before do
    # that's to test the display of results
    stub_ngataonga_harvest_requests(extraction_definition)
    ExtractionJob.new.perform(job.id)
  end
  
  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Name'
    end

    it 'has a record selector' do
      expect(subject.record_selector).to eq '$..results'
    end

    it 'belongs to a content partner' do
      expect(subject.content_partner).to eq content_partner
    end

    it 'has a job' do
      expect(subject.job).to eq job
   end
  end

  describe '#records' do
    it 'returns the records from the job documents' do
      expect(subject.records.first).to have_key 'record_id'
    end
  end

  describe '#transformed_records' do
    it 'returns the records having applied the attributes to them' do
      subject.records.zip(subject.transformed_records).each do |record, transformed_record|
        expect(transformed_record['title']).to eq record['title']
        expect(transformed_record['source']).to eq record['source']
        expect(transformed_record['dc_identifier']).to eq record['reference_number']
        expect(transformed_record['landing_url']).to eq "http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=#{record['record_id']}"
      end
    end
  end
  
  describe '#validations presence of' do
    it { should validate_presence_of(:name).with_message("can't be blank") }
  end
end
