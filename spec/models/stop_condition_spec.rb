# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StopCondition, type: :model do
  let(:pipeline)              { create(:pipeline, :figshare) }
  let(:extraction_definition) { pipeline.harvest.extraction_definition }
  subject                     { create(:stop_condition, extraction_definition:) }

  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Name'
    end

    it 'has content' do
      expect(subject.content).to eq "JsonPath.new('$.page').on(response).first == 1"
    end

    it { is_expected.to belong_to(:extraction_definition) }
  end
end
