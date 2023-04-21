# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::Connection do
  let(:connection) { described_class.new(url: 'test', params: { a: 'b' }, headers: { c: 'd' }) }

  before do
    allow_any_instance_of(described_class).to receive(:connection).and_return(FaradayAdapter.new('test.json'))
  end

  describe '#get' do
    it 'returns the response' do
      expect(described_class.new(url: 'Hello').get).to be_a(Extraction::Response)
    end
  end
end
