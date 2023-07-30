require 'rails_helper'

RSpec.describe Header, type: :model do
  subject { create(:header, extraction_definition:) }

  let(:extraction_definition) { create(:extraction_definition) }

  describe 'validations' do
    subject { build(:header) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:extraction_definition) }
  end
end
