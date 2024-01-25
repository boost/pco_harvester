# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeletePreviousRecords::Execution do
  let(:destination)        { create(:destination) }

  before do
    stub_request(:post, "http://www.localhost:3000/harvester/records/flush").
      with(
        body: "{\"source_id\":\"source_id\",\"job_id\":\"job_id\"}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authentication-Token'=>'testkey',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Supplejack Harvester v2.0'
        }).
      to_return(status: 200, body: "", headers: {})
  end

  describe '#call' do
    it 'sends the source_id and the job_id to the API to trigger the deletion of previously harvested records' do
      expect(described_class.new('source_id', 'job_id', destination).call.status).to eq 200
    end
  end
end
