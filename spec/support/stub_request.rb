# frozen_string_literal: true

require 'webmock/rspec'

def fake_response(filename)
  path = Rails.root.join("spec/stub_responses/#{filename}.json")
  file_content = File.read(path)
  JSON.parse(file_content)
end
