require 'rails_helper'

RSpec.describe ExtractionDefinition, type: :model do
  let!(:extraction_definition) { create(:extraction_definition, name: 'Flickr API') }

  describe '#attributes' do
    it 'has a name' do
      expect(extraction_definition.name).to eq 'Flickr API'
    end

    it 'has a content partner' do
      expect(extraction_definition.content_partner).to be_a ContentPartner
    end
  end

  describe '#validations' do
    it 'requires a name' do
      extraction_definition.name = nil
      expect(extraction_definition).not_to be_valid

      expect(extraction_definition.errors.messages[:name]).to include "can't be blank"
    end

    it 'enforces uniqueness on name' do
      extraction_definition_2 = build(:extraction_definition, name: 'Flickr API')
      expect(extraction_definition_2).not_to be_valid

      expect(extraction_definition_2.errors[:name]).to include "has already been taken"
    end

    it 'requires a content partner' do
      extraction_definition = build(:extraction_definition, content_partner: nil)
      expect(extraction_definition).not_to be_valid

      expect(extraction_definition.errors[:content_partner]).to include "must exist"
    end
  end
end
