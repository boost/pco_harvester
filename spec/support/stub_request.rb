# frozen_string_literal: true

require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm Dir.glob("#{Job::EXTRACTIONS_FOLDER}/*/*")
    FileUtils.rmdir Dir.glob("#{Job::EXTRACTIONS_FOLDER}/*")
  end
end

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
