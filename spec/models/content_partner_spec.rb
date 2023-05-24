# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentPartner, type: :model do
  let!(:content_partner) { create(:content_partner, name: 'National Library of New Zealand') }

  describe '#attributes' do
    it 'has a name' do
      expect(content_partner.name).to eq 'National Library of New Zealand'
    end
  end

  describe '#validations' do
    it 'requires a name' do
      content_partner.name = nil
      expect(content_partner).not_to be_valid

      expect(content_partner.errors.messages[:name]).to include "can't be blank"
    end

    it 'enforces uniqueness on name' do
      content_partner_2 = ContentPartner.new(name: 'National Library of New Zealand')
      expect(content_partner_2).not_to be_valid

      expect(content_partner_2.errors.messages[:name]).to include 'has already been taken'
    end
  end
end
