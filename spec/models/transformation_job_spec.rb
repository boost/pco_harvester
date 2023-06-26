# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransformationJob, type: :model do
  subject(:transformation_job) { create(:transformation_job, extraction_job:, transformation_definition:) }

  let(:content_source) { create(:content_source, name: 'National Library of New Zealand') }
  let(:extraction_job) { create(:extraction_job) }
  let(:transformation_definition) { create(:transformation_definition, content_source:) }

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(transformation_job.name).to eq "#{transformation_definition.name}__job-#{transformation_job.id}"
    end
  end

  describe '#records' do
    it 'returns an empty array if record_selector is empty' do
      transformation_job.transformation_definition.record_selector = nil
      expect(transformation_job.records).to eq []
    end

    context 'when the extracted document is XML' do
      let(:extraction_definition)     { create(:extraction_definition, format: 'XML', pagination_type: 'tokenised', total_selector: '//records/@total', page: 1, per_page_parameter: 'n', per_page: 100, token_parameter: 's', token_value: '*', next_token_path: '//records/@nextStart') }
      let(:extraction_job)            { create(:extraction_job, extraction_definition:) }
      let(:transformation_definition) { create(:transformation_definition, content_source:, record_selector: '//work', extraction_job:) }
      
      before do
        stub_trove_harvest_requests(extraction_definition, 
          {
            1 => '*', 
            2 => 'AoErc3UyMzQwNjY5OTI=',
            3 => 'AoErc3UyMzQwNjcwOTI=',
            4 => 'AoErc3UyMzQwNjcxOTQ='
          }
        )
        
        ExtractionWorker.new.perform(extraction_job.id)
      end

      it 'returns an array of XML objects based on the given record_selector' do
        expect(Nokogiri::XML(subject.records.first).xpath('//@id').first.content).to eq "1"
      end
    end

    context 'when the extracted document is JSON' do
      let(:extraction_definition) { create(:extraction_definition, format: 'JSON', pagination_type: 'tokenised', total_selector: '$.total_results', page: 1, per_page_parameter: 'per_page', per_page: 30, token_parameter: 'id_above', token_value: '0', next_token_path: '$.results[(@.length-1)].id') }
      let(:extraction_job)            { create(:extraction_job, extraction_definition:) }
      let(:transformation_definition) { create(:transformation_definition, content_source:, record_selector: '$.results', extraction_job:) }

      before do
        stub_inaturalist_harvest_requests(extraction_definition, 
          {
            1 => '0', 
            2 => '2098031',
            3 => '4218778',
            4 => '7179629'
          }
        )

        ExtractionWorker.new.perform(extraction_job.id)
      end

      it 'returns an array of JSON objects based on the given record selector' do
        expect(subject.records.first['id']).to eq 391970
      end
    end
  end
end
