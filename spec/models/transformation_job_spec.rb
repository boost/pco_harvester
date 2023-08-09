# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransformationJob, type: :model do
  subject(:transformation_job)    { create(:transformation_job, extraction_job:, transformation_definition:) }

  let(:pipeline)                  { create(:pipeline, name: 'National Library of New Zealand') }
  let(:harvest_definition)        { create(:harvest_definition, transformation_definition:, pipeline:) }
  let(:extraction_job)            { create(:extraction_job) }
  let(:transformation_definition) { create(:transformation_definition) }

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
      let(:extraction_definition) { create(:extraction_definition, format: 'XML', total_selector: '//records/@total', page: 1, per_page: 100) }
      let(:extraction_job)            { create(:extraction_job, extraction_definition:) }
      let(:transformation_definition) { create(:transformation_definition, record_selector: '//work', extraction_job:) }
      let(:request_one)           { create(:request, :trove_initial_request, extraction_definition:) }
      let(:request_two)           { create(:request, :trove_main_request, extraction_definition:) }

      before do
        stub_trove_harvest_requests(request_one,
                                    {
                                      1 => '*',
                                      2 => 'AoErc3UyMzQwNjY5OTI=',
                                      3 => 'AoErc3UyMzQwNjcwOTI=',
                                      4 => 'AoErc3UyMzQwNjcxOTQ='
                                    })

        ExtractionWorker.new.perform(extraction_job.id)
      end

      it 'returns an array of XML objects based on the given record_selector' do
        expect(Nokogiri::XML(subject.records.first).xpath('//@id').first.content).to eq '1'
      end
    end

    context 'when the extracted document is JSON' do
      let(:extraction_definition) { create(:extraction_definition, format: 'JSON', total_selector: '$.total_results', page: 1, paginated: true, per_page: 30) }
      let(:request_one) { create(:request, :inaturalist_initial_request, extraction_definition:) }
      let(:request_two) { create(:request, :inaturalist_main_request, extraction_definition:) }
      let(:extraction_job)            { create(:extraction_job, extraction_definition:) }
      let(:transformation_definition) do
        create(:transformation_definition, record_selector: '$.results', extraction_job:)
      end

      before do
        stub_inaturalist_harvest_requests(request_one,
                                          {
                                            1 => '0',
                                            2 => '2098031',
                                            3 => '4218778',
                                            4 => '7179629'
                                          })

        ExtractionWorker.new.perform(extraction_job.id)
      end

      it 'returns an array of JSON objects based on the given record selector' do
        expect(subject.records.first['id']).to eq 391_970
      end
    end
  end
end
