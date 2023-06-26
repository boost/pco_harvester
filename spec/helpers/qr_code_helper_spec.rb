# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QrCodeHelper do
  subject { qr_code_as_svg('https://google.com') }

  let(:nodes) { Nokogiri::XML::Document.parse(subject) }

  describe '#qr_code_as_svg' do
    it { is_expected.to be_a(String) }

    it 'returns an xml with SVG as first children' do
      expect(nodes.children[0].name).to eq 'svg'
    end
  end
end
