# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentSource, type: :model do
  let!(:content_source) { create(:content_source, name: 'National Library of New Zealand') }

  describe '#attributes' do
    it 'has a name' do
      expect(content_source.name).to eq 'National Library of New Zealand'
    end
  end

  describe '#validations' do
    it 'requires a name' do
      content_source.name = nil
      expect(content_source).not_to be_valid

      expect(content_source.errors.messages[:name]).to include "can't be blank"
    end

    it 'enforces uniqueness on name' do
      content_source_2 = ContentSource.new(name: 'National Library of New Zealand')
      expect(content_source_2).not_to be_valid

      expect(content_source_2.errors.messages[:name]).to include 'has already been taken'
    end
  end
end
