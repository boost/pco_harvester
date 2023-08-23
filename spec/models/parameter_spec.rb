# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parameter, type: :model do
  describe 'validations' do
    subject { build(:parameter) }
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

  describe "#content_type" do
    let(:static)       { create(:parameter, content_type: 0) }
    let(:dynamic)      { create(:parameter, content_type: 1) }
    let(:incremental)  { create(:parameter, content_type: 2) }

    it 'can be static' do
      expect(static.static?).to eq true
    end

    it 'can be dynamic' do
      expect(dynamic.dynamic?).to eq true
    end

    it 'can be incremental' do
      expect(incremental.incremental?).to eq true
    end
  end

  describe '#to_h' do
    let(:query) { create(:parameter, kind: 'query', name: 'itemsPerPage', content: '30') }
    let(:slug)  { create(:parameter, kind: 'slug', content: 'articles') }

    it 'returns a hash of key => value' do
      expect(query.to_h).to eq(
        {
          'itemsPerPage' => '30'
        }
      )
    end

    it 'returns nothing for a slug parameter' do
      expect(slug.to_h).to eq nil
    end
  end

  describe '#evaluate' do
    let(:static)      { create(:parameter, kind: 'query', name: 'itemsPerPage') }
    let(:dynamic)     { create(:parameter, kind: 'query', name: 'itemsPerPage', content: '1 + 1', content_type: 1) }
    let(:incremental) { create(:parameter, kind: 'query', name: 'itemsPerPage', content: '12', content_type: 2) }
    let(:incremental_two) { create(:parameter, kind: 'query', name: 'itemsPerPage', content: '1', content_type: 2) }
    
    let(:dynamic_response) do
      create(:parameter, kind: 'query', name: 'itemsPerPage', content: 'JSON.parse(response)["page_nr"] + 1',
                         content_type: 1)
    end
    let(:response)    { '{ "page_nr": 2 }' }

    it 'returns the unevaluated parameter if it is not dynamic' do
      expect(static.evaluate).to eq static
    end

    it 'returns the evaluated paramter if it is dynamic' do
      expect(dynamic.evaluate.content).to eq '2'
    end

    it 'returns the evaluated parameter based on a response' do
      expect(dynamic_response.evaluate(response).content).to eq '3'
    end

    it 'returns the incremented parameter if it is incremental' do
      expect(incremental.evaluate(nil, 2).content).to eq "12"
    end

    it 'returns the incremented page number if it is incremental and incremented by 1' do
      expect(incremental_two.evaluate(nil, 2).content).to eq "2"
    end
  end
end
