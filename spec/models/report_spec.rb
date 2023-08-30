# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:pipeline)           { create(:pipeline) }
  let(:pipeline_job)       { create(:pipeline_job) }
  let(:harvest_definition) { create(:harvest_definition, pipeline:) }
  subject                  { create(:report, pipeline_job:, harvest_definition:) }

  describe 'associations' do
    it { is_expected.to belong_to(:pipeline_job) }
  end

  describe 'status checks' do
    ['extraction', 'transformation', 'load'].each do |type|
      described_class::STATUSES.each do |status|
        it "defines the check #{type}_#{status}?" do
          subject.send("#{type}_status=", status)
          expect(subject.send("#{type}_#{status}?")).to be true
          subject.send("#{type}_status=", described_class::STATUSES.without(status).sample)
          expect(subject.send("#{type}_#{status}?")).to be false
        end

        it "defines a way to update the status with #{type}_#{status}!" do
          subject.send("#{type}_status=", status)
          expect(subject.send("#{type}_#{status}!")).to be true
          subject.reload
          expect(subject.send("#{type}_#{status}?")).to be true
        end
      end
    end
  end
  
  describe '#increment_pages_extracted!' do
    it 'increments the pages extracted count' do
      expect(subject.pages_extracted).to eq 0
      subject.increment_pages_extracted!
      expect(subject.pages_extracted).to eq 1
    end
  end

  describe '#increment_records_transformed!' do
    it 'increments the records transformed count' do
      expect(subject.records_transformed).to eq 0
      subject.increment_records_transformed!
      expect(subject.records_transformed).to eq 1
    end
  end

  describe '#increment_records_loaded!' do
    it 'increments the records loaded count' do
      expect(subject.records_loaded).to eq 0
      subject.increment_records_loaded!
      expect(subject.records_loaded).to eq 1
    end
  end

  describe '#increment_records_rejected!' do
    it 'increments the records rejected count' do
      expect(subject.records_rejected).to eq 0
      subject.increment_records_rejected!
      expect(subject.records_rejected).to eq 1
    end
  end
  
  describe '#increment_records_deleted!' do
    it 'increments the records deleted count' do
      expect(subject.records_deleted).to eq 0
      subject.increment_records_deleted!
      expect(subject.records_deleted).to eq 1
    end
  end
end