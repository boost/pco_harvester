# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractionWorker, type: :job do
  let(:pipeline)              { create(:pipeline, :ngataonga) }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  let(:extraction_job)        { create(:extraction_job, extraction_definition:, status: 'queued') }
  let(:subject)               { ExtractionWorker.new }

  describe 'options' do
    it 'sets the retry to 0' do
      expect(subject.sidekiq_options_hash['retry']).to eq 0
    end
  end

  describe '#sidekiq_retries_exhausted' do
    it 'marks the job as errored in sidekiq_retries_exhausted' do
      subject.sidekiq_retries_exhausted_block.call({ 'args' => [extraction_job.id] }, nil)
      extraction_job.reload
      expect(extraction_job.errored?).to be true
    end
  end

  describe '#perform' do
    before { stub_ngataonga_harvest_requests(extraction_definition) }

    it 'marks the job as completed' do
      subject.perform(extraction_job.id)
      extraction_job.reload
      expect(extraction_job.completed?).to be true
    end
  end
end
