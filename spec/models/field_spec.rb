# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Field, type: :model do
  let(:content_partner) { create(:content_partner, :ngataonga) }
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, content_partner:, extraction_job:) }
  let(:subject) { create(:field, transformation_definition:) }

  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'title'
    end

    it 'has a block' do
      expect(subject.block).to eq "JsonPath.new('title').on(record).first"
    end

    it 'belongs to a transformation' do
      expect(subject.transformation_definition).to eq transformation_definition
    end
  end
end
