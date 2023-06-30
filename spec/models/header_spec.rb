require 'rails_helper'

RSpec.describe Header, type: :model do
  let(:extraction_definition) { create(:extraction_definition) }
  subject { create(:header, extraction_definition:) }

  describe 'validations' do
    subject { build(:header) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'associations' do
    it 'belongs to an extraction_definition' do
      expect(subject.extraction_definition).to eq extraction_definition
    end
  end
end
