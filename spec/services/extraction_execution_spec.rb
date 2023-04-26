# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExtractionExecution do
  let(:job) { create(:job) }
  let(:ed) { create(:extraction_definition, base_url: 'http://google.com/?url_param=url_value', jobs: [job]) }
  let(:subject) { described_class.new(job, ed) }

  before do
    init_params = {
      url: 'http://google.com/?url_param=url_value',
      params: { 'page' => 1, 'per_page' => 50  },
      headers: { 'Content-Type' => 'application/json', 'User-Agent' => 'Supplejack Harvester v2.0' }
    }

    stub_request(**init_params) { 'test' }
  end

  describe '#call' do
    it 'saves response from the content partner to the filesystem' do
      subject.call
    end
  end
end
