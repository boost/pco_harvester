# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransformationDefinition, type: :model do
  let(:pipeline)              { create(:pipeline, :figshare, name: 'National Library of New Zealand') }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  let(:extraction_job)        { create(:extraction_job, extraction_definition:) }
  let(:request)                 { create(:request, :figshare_initial_request, extraction_definition:) }
  let(:subject) do
    create(:transformation_definition, pipeline:, extraction_job:, record_selector: '$..items')
  end

  let!(:field_one) do
    create(:field, name: 'title', block: "JsonPath.new('title').on(record).first", transformation_definition: subject)
  end
  let!(:field_two) do
    create(:field, name: 'source', block: "JsonPath.new('source').on(record).first", transformation_definition: subject)
  end

  before do
    # that's to test the display of results
    stub_figshare_harvest_requests(request)
    ExtractionWorker.new.perform(extraction_job.id)
  end

  describe '#attributes' do
    it 'has a record selector' do
      expect(subject.record_selector).to eq '$..items'
    end

    it 'belongs to a pipeline' do
      expect(subject.pipeline).to eq pipeline
    end

    it 'has a job' do
      expect(subject.extraction_job).to eq extraction_job
    end
  end

  describe '#records' do
    it 'returns the records from the job documents' do
      expect(subject.records.first).to have_key 'article_id'
    end
  end

  describe 'kinds' do
    let(:harvest_transformation_definition) { create(:transformation_definition, kind: :harvest) }
    let(:enrichment_transformation_definition) { create(:transformation_definition, kind: :enrichment) }

    it 'can be for a harvest' do
      expect(harvest_transformation_definition.harvest?).to be true
    end

    it 'can be for an enrichment' do
      expect(enrichment_transformation_definition.enrichment?).to be true
    end
  end

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(subject.name).to eq "national-library-of-new-zealand__harvest-transformation-#{subject.id}"
    end
  end

  describe '#shared?' do
    let!(:harvest_definition_one) { create(:harvest_definition, transformation_definition: shared, pipeline:) }
    let!(:harvest_definition_two) { create(:harvest_definition, transformation_definition: shared, pipeline:) }
    let!(:harvest_definition_three) { create(:harvest_definition, transformation_definition: standalone, pipeline:) }

    let(:shared)     { create(:transformation_definition, pipeline:) }
    let(:standalone) { create(:transformation_definition, pipeline:) }

    it 'returns true if the transformation definition is used in more than one harvest definition' do
      expect(shared.shared?).to eq true
    end

    it 'returns false if the transformation definition is used in only one harvest definition' do
      expect(standalone.shared?).to eq false
    end
  end
end
