require 'rails_helper'

RSpec.describe ExtractionJob, type: :model do
  subject { create(:extraction_job) }

  describe 'status checks' do
    described_class::STATUSES.each do |status|
      it "defines the check #{status}?" do
        subject.status = status
        expect(subject.send("#{status}?")).to be true
        subject.status = described_class::STATUSES.without(status).sample
        expect(subject.send("#{status}?")).to be false
      end

      it "defines a way to update the status with #{status}!" do
        subject.status = status
        expect(subject.send("#{status}!")).to be true
        subject.reload
        expect(subject.send("#{status}?")).to be true
      end
    end
  end

  describe 'kind checks' do
    described_class::KINDS.each do |kind|
      it "defines the check is_#{kind}?" do
        subject.kind = kind
        expect(subject.send("is_#{kind}?")).to be true
        subject.kind = described_class::KINDS.without(kind).sample
        expect(subject.send("is_#{kind}?")).to be false
      end
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:extraction_definition).with_message('must exist') }
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
      subject.update(start_time: '2023-03-20 11:00:00', end_time: '2023-03-20 11:05:00')
      subject.reload
      expect(subject.duration_seconds).to eq 300
    end
  end

  describe '#extraction_folder_size_in_bytes' do
    let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', extraction_jobs: [subject]) }

    before do
      (1...6).each do |page|
        stub_request(:get, 'http://google.com/?url_param=url_value').with(
          query: { 'page' => page, 'per_page' => 50 },
          headers: fake_json_headers
        ).and_return(fake_response('test'))
      end
    end

    it 'returns the size of the extraction folder in bytes' do
      Extraction::Execution.new(subject, ed).call

      expect(subject.extraction_folder_size_in_bytes).to eq 24
    end
  end
end
