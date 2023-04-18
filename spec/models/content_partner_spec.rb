require 'rails_helper'

RSpec.describe ContentPartner, type: :model do
  let(:content_partner) { create(:content_partner, name: 'National Library of New Zealand') }

  describe '#attributes' do
    it 'has a name' do
      expect(content_partner.name).to eq 'National Library of New Zealand'
    end
  end
end
