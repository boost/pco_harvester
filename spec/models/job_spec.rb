require 'rails_helper'

RSpec.describe Job, type: :model do
  subject { create(:job) }

  describe 'status checks' do
    Job::STATUSES.each do |status|
      it "defines the check #{status}?" do
        subject.status = status
        expect(subject.send("#{status}?")).to be true
        subject.status = 'test'
        expect(subject.send("#{status}?")).to be false
      end

      it "defines a way to update the status with mark_as_#{status}" do
        subject.status = status
        expect(subject.send("mark_as_#{status}")).to be true
        subject.reload
        expect(subject.send("#{status}?")).to be true
      end
    end
  end

  describe 'kind checks' do
    Job::KINDS.each do |kind|
      it "defines the check #{kind}?" do
        subject.kind = kind
        expect(subject.send("#{kind}?")).to be true
        subject.kind = 'test'
        expect(subject.send("#{kind}?")).to be false
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:extraction_definition).with_message('must exist') }
    it { should validate_inclusion_of(:status).in_array(Job::STATUSES).with_message('is not included in the list') }
    it { should validate_inclusion_of(:kind).in_array(Job::KINDS).with_message('is not included in the list') }
  end

  describe '#associations' do
    it 'belongs to an Extraction Definition' do
      expect(subject.extraction_definition).to be_a(ExtractionDefinition)
    end
  end

  describe '#extraction_folder' do
    it 'returns the path for where the extractions are kept' do
      expect(subject.extraction_folder).to eq("#{Rails.root.join('extractions')}/#{Rails.env}/#{subject.created_at.strftime('%Y-%m-%d_%H-%M-%S')}_-_#{subject.id}")
    end
  end

  describe '#create_folder' do
    it 'creates a folder at the Extractions Path' do
      expect(File.exist?(subject.extraction_folder)).to eq true
    end
  end

  describe '#delete_folder' do
    it 'deletes a folder at the extractions path' do
      expect(File.exist?(subject.extraction_folder)).to eq true

      subject.delete_folder

      expect(File.exist?(subject.extraction_folder)).to eq false
    end

    it 'does nothing if the folder does not exist' do
      expect(File.exist?(subject.extraction_folder)).to eq true

      subject.delete_folder

      expect(File.exist?(subject.extraction_folder)).to eq false

      expect { subject.delete_folder }.not_to raise_error
    end
  end

  describe '#documents' do
    it 'returns an Extraction::Documents object' do
      expect(subject.documents).to be_a(Extraction::Documents)
    end
  end
end
