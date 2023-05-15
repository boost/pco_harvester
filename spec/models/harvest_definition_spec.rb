# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestDefinition, type: :model do
  let(:content_partner) { create(:content_partner, :ngataonga) } 
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:job)             { create(:job, extraction_definition:) } 
  let(:transformation_definition) { create(:transformation_definition, content_partner:, job:)}
  let(:destination) { create(:destination) }

  let(:subject) { create(:harvest_definition, name: 'Staging Harvest', content_partner:, extraction_definition:, job:, transformation_definition:, destination:) }

  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Staging Harvest'
    end

    it 'belongs to a content partner' do
      expect(subject.content_partner).to eq content_partner
    end
    
    it 'has an extraction definition' do
      expect(subject.extraction_definition).to eq extraction_definition
    end

    it 'has a job' do
      expect(subject.job).to eq job
    end

    it 'has a transformation definition' do
      expect(subject.transformation_definition).to eq transformation_definition
    end

    it 'has a destination' do
      expect(subject.destination).to eq destination
    end
  end
end
