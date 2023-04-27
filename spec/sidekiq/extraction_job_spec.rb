require 'rails_helper'

RSpec.describe ExtractionJob, type: :job do
  let(:cp) { create(:content_partner, :ngataonga) }
  let(:ed) { cp.extraction_definitions.first }
  let(:job) { create(:job, extraction_definition: ed, status: 'queued') }
  let(:subject) { ExtractionJob.new }

  describe 'options' do
    it 'sets the retry to 0' do
      expect(subject.sidekiq_options_hash['retry']).to eq 0
    end
  end

  describe '#sidekiq_retries_exhausted' do
    it 'marks the job as errored in sidekiq_retries_exhausted' do
      subject.sidekiq_retries_exhausted_block.call({ 'args' => [job.id] }, nil)
      job.reload
      expect(job.errored?).to be true
    end
  end

  describe '#perform' do
    before do
      (1..3).each do |page|
        stub_request(:get, ed.base_url).with(
          query: { 'page' => page, 'per_page' => ed.per_page },
          headers: {
            'Content-Type' => 'application/json',
            'User-Agent' => 'Supplejack Harvester v2.0'
          }
        ).to_return(fake_response("ngataonga_#{page}"))
      end
    end

    it 'marks the job as completed' do
      subject.perform(job.id)
      job.reload
      expect(job.completed?).to be true
    end
  end
end
