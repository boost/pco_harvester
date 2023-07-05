# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Load::Execution do
  let(:record) do
    {
      transformed_record: {
        title: 'title',
        description: 'description'
      }
    }
  end
  let(:content_source)    { create(:content_source, name: 'test') }
  let(:destination)        { create(:destination) }


  describe '#call' do
    context 'when the harvest definition is for a harvest' do

      before do
         stub_request(:post, "http://www.localhost:3000/harvester/records")
           .with(
             body: "{\"record\":{\"title\":\"title\",\"description\":\"description\",\"source_id\":\"test\",\"priority\":0,\"job_id\":\"test__harvest-#{harvest_definition.id}__job-#{harvest_job.id}\"}}",
             headers: {
         	 'Accept'=>'*/*',
         	 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         	 'Authentication-Token'=>'testkey',
         	 'Content-Type'=>'application/json',
         	 'User-Agent'=>'Supplejack Harvester v2.0'
          }).
         to_return(status: 200, body: "", headers: {})
      end

      let(:harvest_definition) { create(:harvest_definition, destination:, content_source:, kind: 'harvest', source_id: 'test') }
      let(:harvest_job)        { create(:harvest_job, harvest_definition:) }
      let(:load_job)           { create(:load_job, harvest_job:) }

      it 'sends the record to the API correctly' do
        expect(Load::Execution.new(record, load_job).call.status).to eq 200
      end
    end

    context 'when the harvest definition is for an enrichment' do
      let(:harvest_definition) { create(:harvest_definition, destination:, content_source:, kind: 'enrichment', source_id: 'test') }
      let(:harvest_job)        { create(:harvest_job, harvest_definition:) }
      let(:load_job)           { create(:load_job, harvest_job:, api_record_id: 'record_id') }

      before do
       stub_request(:post, "http://www.localhost:3000/harvester/records/record_id/fragments.json").
         with(
           body: "{\"fragment\":{\"title\":\"title\",\"description\":\"description\",\"source_id\":\"test\",\"priority\":0,\"job_id\":\"test__enrichment-#{harvest_definition.id}__job-#{harvest_job.id}\"},\"required_fragments\":null}",
           headers: {
       	 'Accept'=>'*/*',
       	 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	 'Authentication-Token'=>'testkey',
       	 'Content-Type'=>'application/json',
       	 'User-Agent'=>'Supplejack Harvester v2.0'
           }).
         to_return(status: 200, body: "", headers: {})
      end

      it 'sends the record to the API correctly' do
        expect(Load::Execution.new(record, load_job).call.status).to eq 200
      end
    end
  end
end
