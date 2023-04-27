# frozen_string_literal: true

require 'webmock/rspec'

def fake_response(filename)
  path = Rails.root.join("spec/stub_responses/#{filename}.json")
  file_content = File.read(path)
  JSON.parse(file_content)
end

def fake_json_headers
  {
    'Content-Type' => 'application/json',
    'User-Agent' => 'Supplejack Harvester v2.0'
  }
end
