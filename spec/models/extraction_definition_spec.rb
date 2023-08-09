# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractionDefinition, type: :model do
  subject! { create(:extraction_definition, pipeline: pipeline1) }

  let!(:pipeline1) { create(:pipeline, name: 'National Library of New Zealand') }
  let!(:pipeline2) { create(:pipeline) }

  describe '#name' do
    it 'autogenerates a sensible name' do
      expect(subject.name).to eq "national-library-of-new-zealand__harvest-extraction-#{subject.id}"
    end
  end

  describe '#validations presence of' do
    context 'when the extraction definition is for a harvest' do
      it { is_expected.to validate_presence_of(:format).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:base_url).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:throttle).with_message('is not a number') }

      it { is_expected.not_to validate_presence_of(:destination_id).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:source_id).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:enrichment_url).with_message("can't be blank") }
    end

    context 'when the extraction definition is for an enrichment' do
      subject! { create(:extraction_definition, :enrichment, pipeline: pipeline1, name: 'Flickr API', destination:) }

      let(:destination) { create(:destination) }

      it { is_expected.to validate_presence_of(:throttle).with_message('is not a number') }
      it { is_expected.to validate_presence_of(:destination_id).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:source_id).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:enrichment_url).with_message("can't be blank") }

      it { is_expected.not_to validate_presence_of(:format).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:base_url).with_message("can't be blank") }
    end
  end

  describe '#validation numericality' do
    it do
      expect(subject).to validate_numericality_of(:throttle)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(60_000)
    end

    it { is_expected.to validate_numericality_of(:page).only_integer }
    it { is_expected.to validate_numericality_of(:per_page).only_integer }
  end

  describe '#validation' do
    it {
      expect(subject).to validate_inclusion_of(:format).in_array(%w[JSON
                                                                    XML]).with_message('is not included in the list')
    }

    it 'requires a pipeline' do
      extraction_definition = build(:extraction_definition, pipeline: nil)
      expect(extraction_definition).not_to be_valid

      expect(extraction_definition.errors[:pipeline]).to include 'must exist'
    end
  end

  describe '#validations base_url' do
    [
      'http://google.com',
      'http://google.com/',
      'https://google.com/',
      'http://google.com:80',
      'http://google.com:443',
      'http://google.com/hello',
      'http://google.com/hello?',
      'http://google.com/?param=value',
      'http://google.com/page?param=value&param2="value"',
      'http://google.com/page?param=value',
      'http://google.com/page?param[sub_param]=value'
    ].each do |base_url|
      it { is_expected.to allow_value(base_url).for(:base_url) }
    end

    [
      'google',
      'google.com'
    ].each do |base_url|
      it { is_expected.not_to allow_value(base_url).for(:base_url) }
    end
  end

  describe '#associations' do
    subject { create(:extraction_definition, extraction_jobs: [extraction_job]) }

    let(:extraction_job) { create(:extraction_job) }

    it 'has many jobs' do
      expect(subject.extraction_jobs).to include(extraction_job)
    end

    it 'belongs to a pipeline' do
      expect(subject.pipeline).to be_a Pipeline
    end
  end

  describe '#kinds' do
    kinds = { harvest: 0, enrichment: 1 }

    kinds.each do |key, value|
      it "can be #{key}" do
        expect(ExtractionDefinition.new(kind: value).kind).to eq(key.to_s)
      end
    end
  end
end
