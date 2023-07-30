# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parameter, type: :model do
  describe 'validations' do
    subject { build(:parameter) }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
  end
  
  describe 'associations' do
    it { is_expected.to belong_to(:request) }
  end

  describe 'kinds' do
    let(:query)  { create(:parameter, kind: 0) }
    let(:header) { create(:parameter, kind: 1) }
    let(:slug)   { create(:parameter, kind: 2) }

    it 'can be a query parameter' do
      expect(query.query?).to eq true
    end

    
    it 'can be a header parameter' do
      expect(header.header?).to eq true
    end

    it 'can be a slug parameter' do
      expect(slug.slug?).to eq true
    end
  end
end
