require 'rails_helper'

RSpec.describe ExtractionDefinition, type: :model do
  let!(:cp1) { create(:content_partner) }
  let!(:cp2) { create(:content_partner) }
  subject! { create(:extraction_definition, content_partner: cp1, name: 'Flickr API') }

  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Flickr API'
    end

    it 'has a content partner' do
      expect(subject.content_partner).to be_a ContentPartner
    end
  end

  describe '#validations presence of' do
    it { should validate_presence_of(:name).with_message("can't be blank") }
    it { should validate_presence_of(:format).with_message("can't be blank") }
    it { should validate_presence_of(:base_url).with_message("can't be blank") }
    it { should validate_presence_of(:throttle).with_message('is not a number') }
  end

  describe '#validation numericality' do
    it do
      should validate_numericality_of(:throttle)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(60_000)
    end

    it { should validate_numericality_of(:page).only_integer }
    it { should validate_numericality_of(:per_page).only_integer }
  end

  describe '#validation' do
    it { should validate_inclusion_of(:format).in_array(%w[JSON HTML XML OAI]).with_message('is not included in the list') }

    it 'requires a unique name scoped to content partner' do
      ed2 = build(:extraction_definition, content_partner: cp2, name: 'Flickr API')
      ed2.content_partner = cp2
      expect(ed2).to be_valid

      ed2.content_partner = cp1
      expect(ed2).to_not be_valid
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
      it { should allow_value(base_url).for(:base_url) }
    end

    [
      'google',
      'google.com'
    ].each do |base_url|
      it { should_not allow_value(base_url).for(:base_url) }
    end
  end
end
