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

  describe '#timestamps' do
    it 'can record when the job was started' do
      subject.update(start_time: Time.now)

      expect(subject.start_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'can record when the job was finished' do
      subject.update(end_time: 1.day.from_now)

      expect(subject.end_time).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'does not allow an end date to be before a start date' do
      subject.start_time = Time.now
      subject.end_time   = 1.day.ago
      expect(subject).not_to be_valid
    end

    it 'returns the number of seconds that the job has been running for' do
      subject.update(start_time: '2023-03-20 11:00:00' , end_time: '2023-03-20 11:05:00' )
      subject.reload
      expect(subject.duration_seconds).to eq 300
    end
  end

  describe '#extraction_folder_size_in_bytes' do
    let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', jobs: [subject]) }

    before do
      (1...6).each do |page|
        init_params = {
          url: 'http://google.com/?url_param=url_value',
          params: { 'page' => page, 'per_page' => 50  },
          headers: { 'Content-Type' => 'application/json', 'User-Agent' => 'Supplejack Harvester v2.0' }
        }

        stub_request(**init_params) { 'test' }
      end
    end

    it 'returns the size of the extraction folder in bytes' do
      ExtractionExecution.new(subject, ed).call

      expect(subject.extraction_folder_size_in_bytes).to eq 40
    end
  end
end
