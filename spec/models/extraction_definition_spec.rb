# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractionDefinition, type: :model do
  subject! { create(:extraction_definition, content_source: cp1) }

  let!(:cp1) { create(:content_source, name: 'National Library of New Zealand') }
  let!(:cp2) { create(:content_source) }

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
      subject! { create(:extraction_definition, :enrichment, content_source: cp1, name: 'Flickr API', destination:) }

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
      expect(subject).to validate_inclusion_of(:format).in_array(%w[JSON XML]).with_message('is not included in the list')
    }

    it 'requires a content source' do
      extraction_definition = build(:extraction_definition, content_source: nil)
      expect(extraction_definition).not_to be_valid

      expect(extraction_definition.errors[:content_source]).to include 'must exist'
    end

    it 'cannot be a copy of itself' do
      subject.original_extraction_definition = subject
      expect(subject).not_to be_valid
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
    let(:extraction_job) { create(:extraction_job) }
    let(:header)         { create(:header) }
    subject { create(:extraction_definition, extraction_jobs: [extraction_job], headers: [header]) }

    it 'has many jobs' do
      expect(subject.extraction_jobs).to include(extraction_job)
    end

    it 'belongs to a content source' do
      expect(subject.content_source).to be_a ContentSource
    end

    it 'has many headers' do
      expect(subject.headers).to include(header)
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

  describe "#copy?" do
    let(:destination) { create(:destination) }
    let(:original) { create(:extraction_definition, :enrichment, content_source: cp1, name: 'Flickr API', destination:) }
    let(:copy) { create(:extraction_definition, :enrichment, content_source: cp1, name: 'Flickr API', destination:, original_extraction_definition: original) }

    it 'returns true if the extraction definition is a copy' do
      expect(copy.copy?).to eq true
    end

    it 'returns false if the extraction definition is an original' do
      expect(original.copy?).to eq false
    end
  end

  describe '#pagination_type' do
    [
      'page',
      'tokenised'
    ].each do |pagination_type|
      it { is_expected.to allow_value(pagination_type).for(:pagination_type) }
    end

    context 'when the type is tokenised' do
      subject! { build(:extraction_definition, name: 'Flickr API', pagination_type: 'tokenised') }
      it { is_expected.to validate_presence_of(:next_token_path).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:token_parameter).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:token_value).with_message("can't be blank") }
      it { is_expected.to validate_presence_of(:total_selector).with_message("can't be blank") }
    end

    context 'when the type is page' do
      subject! { build(:extraction_definition, name: 'Flickr API', pagination_type: 'page') }
      it { is_expected.to validate_presence_of(:total_selector).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:next_token_path).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:token_parameter).with_message("can't be blank") }
      it { is_expected.not_to validate_presence_of(:token_value).with_message("can't be blank") }
    end
  end
end
