# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractionDefinition, type: :model do
  subject! { create(:extraction_definition, content_partner: cp1, name: 'Flickr API') }

  let!(:cp1) { create(:content_partner) }
  let!(:cp2) { create(:content_partner) }

  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Flickr API'
    end
  end

  describe '#validations presence of' do
    it { is_expected.to validate_presence_of(:name).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:format).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:base_url).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:throttle).with_message('is not a number') }
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
      expect(subject).to validate_inclusion_of(:format).in_array(%w[JSON HTML XML
                                                                    OAI]).with_message('is not included in the list')
    }

    it 'requires a unique name scoped to content partner' do
      ed2 = build(:extraction_definition, content_partner: cp2, name: 'Flickr API')
      ed2.content_partner = cp2
      expect(ed2).to be_valid

      ed2.content_partner = cp1
      expect(ed2).not_to be_valid
    end

    it 'requires a content partner' do
      extraction_definition = build(:extraction_definition, content_partner: nil)
      expect(extraction_definition).not_to be_valid

      expect(extraction_definition.errors[:content_partner]).to include 'must exist'
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
    let(:ed) { create(:extraction_definition, extraction_jobs: [extraction_job]) }

    it 'has many jobs' do
      expect(ed.extraction_jobs).to include extraction_job
    end

    it 'belongs to a content partner' do
      expect(subject.content_partner).to be_a ContentPartner
    end
  end

  describe 'type' do
    let(:harvest_ed) { create(:extraction_definition, :harvest) }
    let(:enrichment_ed) { create(:extraction_definition, :enrichment) }

    it 'can be a harvest' do
      expect(harvest_ed.harvest?).to eq true
    end

    it 'can be an enrichment' do
      expect(enrichment_ed.enrichment?).to eq true
    end
  end
end
