# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PipelinesHelper, type: :helper do
  let(:pipeline) { create(:pipeline) }

  describe '#reference?' do
    let(:extraction_definition) { create(:extraction_definition, pipeline:) }
    let(:transformation_definition) { create(:transformation_definition) }

    it 'returns true if the definition is not directly associated to the provided pipeline' do
      expect(reference?(pipeline, transformation_definition)).to eq true
    end

    it 'returns false if the definition is directly associated to the provided pipeline' do
      expect(reference?(pipeline, extraction_definition)).to eq false
    end
  end

  describe '#definition_help_text' do
    context 'when the harvest_definition has no extraction' do
      let(:harvest_definition) do
        create(:harvest_definition, pipeline:, extraction_definition: nil, transformation_definition: nil)
      end

      it 'returns a helpful message' do
        expect(definition_help_text(harvest_definition, 'harvest')).to eq 'Please add a harvest extraction'
      end
    end

    context 'when the harvest_definition has no transformation_definition' do
      context 'when the harvest_definition has a completed extraction job' do
        let(:harvest_definition) { create(:harvest_definition, pipeline:, transformation_definition: nil) }
        let!(:extraction_job) do
          create(:extraction_job, extraction_definition: harvest_definition.extraction_definition, status: 'completed')
        end

        it 'returns a helpful message' do
          expect(definition_help_text(harvest_definition,
                                      'harvest')).to eq 'Extraction sample is complete, please add your harvest transformation'
        end
      end

      context 'when the harvest_definition does not have a completed extraction job' do
        let(:harvest_definition) { create(:harvest_definition, pipeline:, transformation_definition: nil) }
        let!(:extraction_job) do
          create(:extraction_job, extraction_definition: harvest_definition.extraction_definition, status: 'running')
        end

        it 'returns a helpful message' do
          expect(definition_help_text(harvest_definition,
                                      'harvest')).to eq 'Extraction sample is not ready, please refresh the page to see when it is completed'
        end
      end
    end

    context 'when the harvest_definition has a transformation definition' do
      context 'when the transformation definition doesnt have any fields' do
        let(:harvest_definition) { create(:harvest_definition, pipeline:) }
        let!(:extraction_job) do
          create(:extraction_job, extraction_definition: harvest_definition.extraction_definition, status: 'completed')
        end

        it 'returns a helpful message' do
          expect(definition_help_text(harvest_definition,
                                      'harvest')).to eq 'Please add fields to your transformation definition'
        end
      end

      context 'when the transformation definition has fields' do
        let(:harvest_definition) { create(:harvest_definition, pipeline:) }
        let!(:extraction_job) do
          create(:extraction_job, extraction_definition: harvest_definition.extraction_definition, status: 'completed')
        end
        let!(:field) do
          create(:field, name: 'title', block: "JsonPath.new('title').on(record).first",
                         transformation_definition: harvest_definition.transformation_definition)
        end

        it 'returns a helpful message' do
          expect(definition_help_text(harvest_definition, 'harvest')).to eq 'Your harvest is ready to run'
        end
      end
    end
  end
end
