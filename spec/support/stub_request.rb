# frozen_string_literal: true

unless Extraction::Connection.private_method_defined?(:connection)
  abort('
    You changed how to make external requests.
    Please make sure we do not make external API calls during tests."
  ')
end

module Extraction
  class Connection
    private

    def connection(url, params, headers)
      stubs = Faraday::Adapter::Test::Stubs.new
      Faraday.new(url:, params:, headers:) { |b| b.adapter(:test, stubs) }
    end
  end
end

class FakeResponse
  def initialize(file)
    path = Rails.root.join("spec/stub_responses/#{file}.json")
    file_content = File.read(path)

    @response = JSON.parse(file_content)
  end

  def build_array
    [
      @response['status'],
      @response['headers'],
      @response['body']
    ]
  end
end

def stub_request(url:, params: {}, headers: {}, &block)
  stubs = Faraday::Adapter::Test::Stubs.new
  conn = Faraday.new(url:, params:, headers:) { |b| b.adapter(:test, stubs) }

  allow_any_instance_of(Extraction::Connection).to(
    receive(:connection)
    .with(url, params, headers)
    .and_return(conn)
  )

  file_basename = block.call
  stubs.get(conn.build_url) { FakeResponse.new(file_basename).build_array }
end
