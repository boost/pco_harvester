# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobsHelper do
  let(:queued_job)         { create(:job) }
  let(:full_running_job)   { create(:job, status: 'running') }
  let(:sample_running_job) { create(:job, kind: 'sample', status: 'running') }
  let(:errored_job)        { create(:job, status: 'errored') }
  let(:cancelled_job)      { create(:job, status: 'cancelled') }
  let(:completed_job)      { create(:job, status: 'completed') }

  describe '#job_status_text' do
    it 'returns Waiting in queue... for queued jobs' do
      expect(job_status_text(queued_job)).to eq 'Waiting in queue...'
    end

    it 'returns Running full job... when running a full job' do
      expect(job_status_text(full_running_job)).to eq 'Running full job...'
    end

    it 'returns Running sample job... when running a sample job' do
      expect(job_status_text(sample_running_job)).to eq 'Running sample job...'
    end

    it 'returns An error occured when an error occured' do
      expect(job_status_text(errored_job)).to eq 'An error occured'
    end

    it 'returns Cancelled when a job is cancelled' do
      expect(job_status_text(cancelled_job)).to eq 'Cancelled'
    end

    it 'returns Completed when a job is completed' do
      expect(job_status_text(completed_job)).to eq 'Completed'
    end
  end
end
