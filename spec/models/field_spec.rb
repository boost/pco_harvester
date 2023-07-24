# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Field, type: :model do
  let(:pipeline) { create(:pipeline, :ngataonga) }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, pipeline:, extraction_job:) }
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

  describe 'kinds' do
    let(:field)     { create(:field, transformation_definition:) }
    let(:condition) { create(:field, kind: 1, transformation_definition:) }

    it 'can be a field' do
      expect(field.field?).to eq true
      expect(field.condition?).to eq false
    end

    it 'can be a condition' do
      expect(condition.condition?).to eq true
      expect(condition.field?).to eq false
    end

    context 'when it is a condition field' do
      let(:reject) { create(:field, kind: 1, transformation_definition:, condition: 0) }
      let(:delete) { create(:field, kind: 1, transformation_definition:, condition: 1) }

      it 'can be a reject_condition' do
        expect(reject.reject_if?).to eq true
      end

      it 'can be a delete_condition' do
        expect(delete.delete_if?).to eq true
      end
    end
  end
end
