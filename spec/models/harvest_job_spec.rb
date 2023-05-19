# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestJob, type: :model do
  subject(:harvest_job) { harvest_jobs(:figshare) }

  describe '#duration_seconds' do
    it 'returns nil if extraction_job is nil' do
      harvest_job.extraction_job = nil
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if load_jobs is empty' do
      harvest_job.load_jobs = []
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if no load jobs have an end_time' do
      harvest_job.load_jobs.update(end_time: nil)
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if extraction_job has no start_time' do
      harvest_job.extraction_job.update(start_time: nil)
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns the number of seconds between the extraction start_time and the max load_job end_time' do
      expect(harvest_job.duration_seconds).to eq 5_760.0
    end
  end

  describe '#transformation_and_load_duration_seconds' do
    it 'returns nil if transformation jobs is empty' do
      harvest_job.transformation_jobs = []
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if load_jobs is empty' do
      harvest_job.load_jobs = []
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if no load jobs have an end_time' do
      harvest_job.load_jobs.update(end_time: nil)
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if transformation jobs have no start_time' do
      harvest_job.transformation_jobs.update(start_time: nil, end_time: nil)
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns the number of seconds between the extraction start_time and the max load_job end_time' do
      expect(harvest_job.transformation_and_load_duration_seconds).to eq 360.0
    end
  end
end
