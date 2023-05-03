# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attribute, type: :model do
  let(:content_partner)       { create(:content_partner, :ngataonga) }
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:job)                   { create(:job, extraction_definition:) } 
  let(:transformation)        { create(:transformation, content_partner:, job:)}
  let(:subject)               { create(:attribute, transformation:) }
  
  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Title'
    end

    it 'has a description' do
      expect(subject.description).to eq 'Description'
    end

    it 'has a block' do
      expect(subject.block).to eq "record['title']"
    end

    it 'belongs to a transformation' do
      expect(subject.transformation).to eq transformation
    end
  end
end
