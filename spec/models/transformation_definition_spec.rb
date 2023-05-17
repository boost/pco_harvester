require 'rails_helper'

RSpec.describe TransformationDefinition, type: :model do
  let(:content_partner) { create(:content_partner, :ngataonga) } 
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:job)             { create(:job, extraction_definition:) } 
  let(:subject)         { create(:transformation_definition, content_partner: content_partner, job: job) }

  let!(:field_one)   { create(:field, name: 'title', block: "JsonPath.new('title').on(record).first", transformation_definition: subject) }
  let!(:field_two)   { create(:field, name: 'source', block: "JsonPath.new('source').on(record).first", transformation_definition: subject) }
  let!(:field_three) { create(:field, name: 'dc_identifier', block: "JsonPath.new('reference_number').on(record).first", transformation_definition: subject) }
  let!(:field_four) { create(:field, name: 'landing_url', block: '"http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=#{record[\'record_id\']}"', transformation_definition: subject) }
  
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
  
  describe '#validations presence of' do
    it { should validate_presence_of(:name).with_message("can't be blank") }
  end
end
