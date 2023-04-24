require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'status checks' do
    subject { create(:job) }

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

  describe 'validations' do
    it { should validate_presence_of(:extraction_definition).with_message('must exist') }
    it { should validate_inclusion_of(:status).in_array(Job::STATUSES).with_message('is not included in the list') }
  end
end
