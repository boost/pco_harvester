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
  end
end
